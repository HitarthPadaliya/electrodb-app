export class HttpError extends Error {
  constructor(status, message) { super(message); this.status = status; }
}
export function positiveInteger(value, name = 'id', fallback) {
  if (value === undefined && fallback !== undefined) return fallback;
  if (typeof value !== 'string' || !/^[1-9]\d*$/.test(value)) {
    throw new HttpError(400, `${name} must be a positive integer`);
  }
  const n = Number(value);
  if (!Number.isSafeInteger(n) || n > 2147483647) throw new HttpError(400, `${name} is too large`);
  return n;
}
export function paging(query) {
  const page = positiveInteger(query.page, 'page', 1);
  const limit = positiveInteger(query.limit, 'limit', 12);
  if (limit > 100 || page > 1000000) throw new HttpError(400, 'Pagination exceeds the supported range');
  return { page, limit, offset: (page - 1) * limit };
}
export function searchTerm(value) {
  if (value === undefined) return '';
  if (typeof value !== 'string' || value.length > 200) throw new HttpError(400, 'q must be a string of at most 200 characters');
  return value.trim();
}
export function likePattern(value) {
  // Explicit ! escape avoids depending on the server's backslash SQL mode.
  return `%${value.replace(/[!%_]/g, '!$&')}%`;
}
export function descendants(rows, id) {
  const children = new Map();
  for (const row of rows) {
    const list = children.get(row.parent_category_id) || [];
    list.push(row.category_id); children.set(row.parent_category_id, list);
  }
  const seen = new Set(); const pending = [id];
  while (pending.length) {
    const current = pending.pop();
    if (seen.has(current)) continue;
    seen.add(current); pending.push(...(children.get(current) || []));
  }
  return [...seen];
}
export function breadcrumbs(rows, id) {
  const byId = new Map(rows.map(row => [row.category_id, row]));
  const result = []; const seen = new Set(); let current = byId.get(id);
  while (current && !seen.has(current.category_id)) {
    seen.add(current.category_id);
    result.unshift({ category_id: current.category_id, name: current.name });
    current = byId.get(current.parent_category_id);
  }
  return result;
}
export function categoryTree(rows) {
  const byId = new Map(rows.map(row => [row.category_id, { ...row, children: [] }]));
  const roots = [];
  for (const row of rows) {
    const node = byId.get(row.category_id);
    const parent = byId.get(row.parent_category_id);
    // Corrupt/cyclic records become roots rather than a circular JSON object.
    const path = new Set([row.category_id]); let ancestor = parent; let cyclic = false;
    while (ancestor) {
      if (path.has(ancestor.category_id)) { cyclic = true; break; }
      path.add(ancestor.category_id); ancestor = byId.get(ancestor.parent_category_id);
    }
    if (parent && !cyclic) parent.children.push(node); else roots.push(node);
  }
  return roots;
}
export function normalizeContent(row) {
  const result = { ...row, table_data: null, parse_error: null };
  if (row.data_format !== 'TABLE') return result;
  try {
    const value = JSON.parse(row.content);
    const valid = Array.isArray(value) && value.every(item => item !== null &&
      typeof item === 'object' && !Array.isArray(item) &&
      Object.values(item).every(cell => cell === null || ['string', 'number', 'boolean'].includes(typeof cell)));
    if (!valid) throw new Error('Expected an array of records with scalar values');
    result.table_data = value;
  } catch {
    result.parse_error = 'Table content is not a valid JSON array of records. Showing the stored text instead.';
  }
  return result;
}
