import { HttpError, positiveInteger, paging, searchTerm, likePattern,
  descendants, breadcrumbs, categoryTree, normalizeContent } from './utils.js';

export function catalogue(pool) {
  const rows = async (sql, params = []) => (await pool.execute(sql, params))[0];
  async function categories() {
    return rows(`SELECT c.category_id, c.parent_category_id, c.name, c.description,
      (SELECT COUNT(*) FROM components p WHERE p.category_id=c.category_id) AS component_count
      FROM categories c ORDER BY c.name, c.category_id`);
  }
  async function list(query) {
    const { page, limit, offset } = paging(query);
    const q = searchTerm(query.q);
    const filters = []; const params = [];
    if (q) {
      filters.push(`(p.name LIKE ? ESCAPE '!' OR p.short_description LIKE ? ESCAPE '!' OR p.description LIKE ? ESCAPE '!')`);
      params.push(likePattern(q), likePattern(q), likePattern(q));
    }
    if (query.category_id !== undefined) {
      const id = positiveInteger(query.category_id, 'category_id');
      const cats = await categories();
      if (!cats.some(c => c.category_id === id)) throw new HttpError(404, 'Category not found');
      if (query.include_descendants !== undefined && !['true', 'false'].includes(query.include_descendants)) {
        throw new HttpError(400, 'include_descendants must be true or false');
      }
      const ids = query.include_descendants === 'true' ? descendants(cats, id) : [id];
      filters.push(`p.category_id IN (${ids.map(() => '?').join(',')})`); params.push(...ids);
    }
    if (query.tag_id !== undefined) {
      filters.push('EXISTS (SELECT 1 FROM component_tag t WHERE t.component_id=p.component_id AND t.tag_id=?)');
      params.push(positiveInteger(query.tag_id, 'tag_id'));
    }
    const sorts = { name_asc: 'p.name ASC, p.component_id ASC', name_desc: 'p.name DESC, p.component_id DESC', id_desc: 'p.component_id DESC' };
    const sort = query.sort ?? 'name_asc';
    if (typeof sort !== 'string' || !Object.hasOwn(sorts, sort)) throw new HttpError(400, 'Unsupported sort order');
    const where = filters.length ? `WHERE ${filters.join(' AND ')}` : '';
    const [{ total }] = await rows(`SELECT COUNT(*) AS total FROM components p ${where}`, params);
    // These two values are validated integers, not user-supplied SQL fragments.
    const data = await rows(`SELECT p.component_id, p.category_id, p.name, p.slug,
      p.short_description, p.image_url, c.name AS category_name
      FROM components p JOIN categories c ON c.category_id=p.category_id ${where}
      ORDER BY ${sorts[sort]} LIMIT ${limit} OFFSET ${offset}`, params);
    return { data, pagination: { page, limit, total: Number(total), pages: Math.ceil(Number(total) / limit) } };
  }
  return {
    categories: async () => { const flat = await categories(); return { data: categoryTree(flat), flat }; },
    category: async rawId => {
      const id = positiveInteger(rawId, 'categoryId');
      const flat = await categories(); const category = flat.find(c => c.category_id === id);
      if (!category) throw new HttpError(404, 'Category not found');
      const template = await rows(`SELECT ct.content_type_id, ct.name, ct.data_format,
        cct.is_required, cct.display_order FROM category_content_types cct
        JOIN content_types ct ON ct.content_type_id=cct.content_type_id
        WHERE cct.category_id=? ORDER BY cct.display_order, ct.content_type_id`, [id]);
      return { data: { ...category, breadcrumbs: breadcrumbs(flat, id),
        children: flat.filter(c => c.parent_category_id === id), content_template: template } };
    },
    list,
    component: async rawId => {
      const id = positiveInteger(rawId, 'componentId');
      const [component] = await rows(`SELECT p.*, c.name AS category_name FROM components p
        JOIN categories c ON c.category_id=p.category_id WHERE p.component_id=?`, [id]);
      if (!component) throw new HttpError(404, 'Component not found');
      const [flat, content, specifications, tags, template, related] = await Promise.all([
        categories(),
        rows(`SELECT cc.*, ct.name AS content_type_name, ct.data_format,
          cct.display_order AS category_display_order, COALESCE(cct.is_required,0) AS is_required
          FROM component_content cc JOIN content_types ct ON ct.content_type_id=cc.content_type_id
          LEFT JOIN category_content_types cct ON cct.category_id=? AND cct.content_type_id=cc.content_type_id
          WHERE cc.component_id=?
          ORDER BY COALESCE(cct.display_order,cc.display_order), cc.display_order, cc.content_id`, [component.category_id, id]),
        rows(`SELECT s.specification_id, s.name, s.unit, cs.value FROM component_specifications cs
          JOIN specifications s ON s.specification_id=cs.specification_id
          WHERE cs.component_id=? ORDER BY s.specification_id`, [id]),
        rows(`SELECT t.tag_id,t.tag_name FROM tags t JOIN component_tag x ON x.tag_id=t.tag_id
          WHERE x.component_id=? ORDER BY t.tag_name`, [id]),
        rows(`SELECT ct.content_type_id,ct.name,ct.data_format,cct.is_required,cct.display_order
          FROM category_content_types cct JOIN content_types ct ON ct.content_type_id=cct.content_type_id
          WHERE cct.category_id=? ORDER BY cct.display_order`, [component.category_id]),
        rows(`SELECT p.component_id,p.name,p.short_description,p.image_url,p.category_id,c.name AS category_name
          FROM components p JOIN categories c ON c.category_id=p.category_id
          WHERE p.category_id=? AND p.component_id<>? ORDER BY p.name LIMIT 4`, [component.category_id,id]),
      ]);
      const missing_required_content = template.filter(t => t.is_required &&
        !content.some(c => c.content_type_id === t.content_type_id) &&
        !(t.name === 'Electrical Specifications' && specifications.length) &&
        !(t.name === 'Working Principle' && component.working_principle) &&
        !(t.name === 'Circuit Symbol' && component.circuit_symbol_url));
      return { data: { ...component, breadcrumbs: breadcrumbs(flat, component.category_id),
        content: content.map(normalizeContent), specifications, tags, content_template: template,
        missing_required_content, related } };
    },
    stats: async () => ({ data: (await rows(`SELECT
      (SELECT COUNT(*) FROM components) AS components,
      (SELECT COUNT(*) FROM categories) AS categories,
      (SELECT COUNT(*) FROM content_types) AS content_types,
      (SELECT COUNT(*) FROM tags) AS tags`))[0] }),
    tags: async () => ({ data: await rows(`SELECT t.tag_id,t.tag_name,COUNT(x.component_id) AS component_count
      FROM tags t LEFT JOIN component_tag x ON x.tag_id=t.tag_id
      GROUP BY t.tag_id,t.tag_name ORDER BY t.tag_name`) }),
    contentTypes: async () => ({ data: await rows('SELECT * FROM content_types ORDER BY content_type_id') }),
    specifications: async () => ({ data: await rows('SELECT * FROM specifications ORDER BY specification_id') }),
  };
}
