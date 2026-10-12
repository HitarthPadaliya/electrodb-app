export function el(tag, attrs = {}, ...children) {
  const node = document.createElement(tag);
  for (const [name, value] of Object.entries(attrs)) {
    if (value === undefined || value === null) continue;
    if (name === 'class') node.className = value;
    else node.setAttribute(name, String(value));
  }
  for (const child of children.flat(Infinity)) {
    if (child === null || child === undefined || child === false) continue;
    node.append(child instanceof Node ? child : document.createTextNode(String(child)));
  }
  return node;
}
export function safeResource(value, origin = window.location.origin) {
  if (typeof value !== 'string' || !value.trim()) return null;
  try {
    const url = new URL(value.trim(), origin);
    if (url.username || url.password) return null;
    if (url.protocol !== 'https:' && !(url.protocol === 'http:' && url.origin === origin)) return null;
    return url.href;
  } catch { return null; }
}
export function missingMedia(label = 'Diagram') {
  return el('div', { class: 'media-missing' }, el('span', { class: 'placeholder-glyph', 'aria-hidden': 'true' }, '─[ ]─'),
    el('span', {}, `${label} not available`), el('small', {}, 'The referenced asset has not been supplied.'));
}
export function media(path, label, compact = false) {
  const wrap = el(compact ? 'div' : 'figure', { class: compact ? 'card-media' : 'media-figure' });
  const url = safeResource(path);
  if (!url) { wrap.append(missingMedia(compact ? 'Image' : label)); return wrap; }
  const image = el('img', { src: url, alt: label, loading: 'lazy', decoding: 'async', referrerpolicy: 'no-referrer' });
  const contents = compact ? image : el('a', { href: url, target: '_blank', rel: 'noopener noreferrer', class: 'resource-link' }, image);
  wrap.append(contents);
  if (!compact) wrap.append(el('figcaption', {}, `${label} · Open full size`));
  image.addEventListener('error', () => wrap.replaceChildren(missingMedia(compact ? 'Image' : label)), { once: true });
  return wrap;
}
export function equation(text, inline = false) {
  const node = el(inline ? 'span' : 'div', { class: inline ? 'inline-equation' : 'equation' }, text);
  if (window.katex && typeof text === 'string') {
    try { window.katex.render(text, node, { displayMode: !inline, throwOnError: false,
      trust: false, strict: 'ignore', maxExpand: 1000, maxSize: 20, output: 'htmlAndMathml' }); }
    catch { node.textContent = text; }
  }
  return node;
}
export function tableHeaders(rows) {
  return [...new Set(rows.flatMap(row => Object.keys(row)))];
}
export function headerLabel(key) {
  const labels = { Q_t: 'Q (current)', Q_next: 'Q (next)', current: 'Current state', next: 'Next state',
    operation: 'Operation', valid: 'Valid' };
  return Object.hasOwn(labels, key) ? labels[key] : key.replaceAll('_', ' ');
}
export function dataTable(rows, caption, technical = false) {
  if (!rows.length) return el('p', { class: 'muted' }, 'No rows have been provided for this table.');
  const columns = tableHeaders(rows);
  if (!columns.length) return el('p', { class: 'muted' }, 'No columns have been provided for this table.');
  const table = el('table', { class: technical ? 'technical-table' : '' }, el('caption', {}, caption),
    el('thead', {}, el('tr', {}, columns.map(key => el('th', { scope: 'col' }, headerLabel(key))))));
  table.append(el('tbody', {}, rows.map(row => el('tr', {}, columns.map(key => {
    const value = row[key] ?? '—';
    return el('td', {}, typeof value === 'string' && value.includes('\\') ? equation(value, true) : String(value));
  })))));
  const wrap = el('div', {}, el('div', { class: 'table-scroll', tabindex: '0', 'aria-label': caption }, table));
  if (technical && rows.some(row => Object.values(row).includes('X'))) {
    wrap.append(el('p', { class: 'table-note' }, 'X means “don’t care”: either binary value is acceptable for that condition.'));
  }
  return wrap;
}
export function renderContent(section) {
  const text = section.content ?? '';
  switch (section.data_format) {
    case 'TEXT': return el('p', { class: 'prose' }, text);
    case 'EQUATION': return equation(text);
    case 'TABLE':
      if (Array.isArray(section.table_data)) return dataTable(section.table_data, section.title || section.content_type_name, true);
      return el('div', {}, el('p', { class: 'notice' }, section.parse_error || 'This table could not be formatted. Showing the original stored text.'),
        el('pre', { class: 'raw-content' }, text));
    case 'IMAGE': case 'DIAGRAM': case 'TIMING_DIAGRAM': case 'GRAPH':
      return media(text, section.title || section.content_type_name);
    case 'DOCUMENT': {
      const url = safeResource(text);
      return url ? el('a', { class: 'button', href: url, target: '_blank', rel: 'noopener noreferrer' }, 'Open document ↗') :
        el('p', { class: 'notice' }, 'No valid document link has been provided.');
    }
    default: return el('pre', { class: 'raw-content' }, text);
  }
}
export function categoryCard(category) {
  return el('a', { class: 'category-card', href: `/categories/${category.category_id}` },
    el('span', { class: 'category-icon', 'aria-hidden': 'true' }, '⌘'),
    el('h3', {}, category.name), el('p', {}, category.description || 'Explore this category.'),
    el('div', { class: 'card-meta' }, el('span', {}, `${category.component_count ?? 0} directly assigned components`), el('span', { class: 'arrow', 'aria-hidden': 'true' }, '↗')));
}
export function componentCard(component) {
  const card = el('article', { class: 'component-card' });
  if (component.image_url) card.append(media(component.image_url, component.name, true));
  card.append(el('div', { class: 'card-body' },
    el('a', { class: 'pill', href: `/categories/${component.category_id}` }, component.category_name),
    el('h3', {}, el('a', { href: `/components/${component.component_id}` }, component.name)),
    el('p', {}, component.short_description || 'Open this entry to learn more.'),
    el('div', { class: 'card-meta' }, el('span', {}, `Reference #${component.component_id}`), el('span', {}, 'View details →'))));
  return card;
}
export function breadcrumb(items = [], current) {
  const nav = el('nav', { class: 'breadcrumb', 'aria-label': 'Breadcrumb' }, el('a', { href: '/' }, 'Home'));
  for (const item of items) nav.append(el('span', { 'aria-hidden': 'true' }, '/'), el('a', { href: `/categories/${item.category_id}` }, item.name));
  if (current) nav.append(el('span', { 'aria-hidden': 'true' }, '/'), el('span', { 'aria-current': 'page' }, current));
  return nav;
}
export function empty(title, description) {
  return el('div', { class: 'empty-state' }, el('h2', {}, title), el('p', {}, description), el('a', { class: 'button', href: '/browse' }, 'Browse all components'));
}
export function pagination(info, url) {
  if (info.pages <= 1) return null;
  const nav = el('nav', { class: 'pagination', 'aria-label': 'Results pagination' });
  const link = page => { const next = new URL(url); next.searchParams.set('page', page); return next.pathname + next.search; };
  if (info.page > 1) nav.append(el('a', { class: 'button', href: link(info.page - 1), rel: 'prev' }, '← Previous'));
  nav.append(el('span', {}, `Page ${info.page} of ${info.pages}`));
  if (info.page < info.pages) nav.append(el('a', { class: 'button', href: link(info.page + 1), rel: 'next' }, 'Next →'));
  return nav;
}
