import { api } from './api.js';
import { el, media, renderContent, categoryCard, componentCard, breadcrumb, dataTable, empty, pagination } from './render.js';
const main = document.querySelector('#main');
let categoriesPromise; let tagsPromise; let controller; let routeVersion = 0;
const getCategories = () => categoriesPromise ??= api.categories().catch(error => { categoriesPromise = undefined; throw error; });
const getTags = () => tagsPromise ??= api.tags().catch(error => { tagsPromise = undefined; throw error; });
function stored(key) { try { return localStorage.getItem(key); } catch { return null; } }
function save(key, value) { try { localStorage.setItem(key, value); } catch { /* Storage may be disabled. */ } }
function setTheme(theme) {
  document.documentElement.dataset.theme = theme;
  document.querySelector('#theme-toggle').setAttribute('aria-label', `Switch to ${theme === 'dark' ? 'light' : 'dark'} theme`);
}
setTheme(stored('electrodb-theme') || (matchMedia('(prefers-color-scheme: light)').matches ? 'light' : 'dark'));
document.querySelector('#theme-toggle').addEventListener('click', () => {
  const theme = document.documentElement.dataset.theme === 'dark' ? 'light' : 'dark';
  setTheme(theme); save('electrodb-theme', theme);
});
function closeMenu() {
  document.querySelector('#sidebar').classList.remove('is-open');
  document.querySelector('#menu-toggle').setAttribute('aria-expanded', 'false');
}
document.querySelector('#menu-toggle').addEventListener('click', event => {
  const open = document.querySelector('#sidebar').classList.toggle('is-open');
  event.currentTarget.setAttribute('aria-expanded', String(open));
});
document.addEventListener('keydown', event => { if (event.key === 'Escape') closeMenu(); });
function sectionHead(title, href, linkLabel) {
  return el('div', { class: 'section-head' }, el('h2', {}, title), href ? el('a', { class: 'text-link', href }, linkLabel || 'View all →') : null);
}
function grid(data, renderer) { return el('div', { class: 'card-grid' }, data.map(renderer)); }
function rememberList(url) { try { sessionStorage.setItem('electrodb-list', url.pathname + url.search); } catch {} }
function backLink(categoryId) {
  let last; try { last = sessionStorage.getItem('electrodb-list'); } catch {}
  if (last && /^\/(search|browse|categories\/\d+)(\?|$)/.test(last)) return el('a', { class: 'back-link', href: last }, '← Back to results');
  return el('a', { class: 'back-link', href: `/categories/${categoryId}` }, '← Back to category');
}
function treeNode(category) {
  const link = el('a', { class: 'tree-link', href: `/categories/${category.category_id}`, 'data-category-id': category.category_id },
    el('span', {}, category.name), category.component_count ? el('span', { class: 'tiny-badge', 'aria-label': `${category.component_count} directly assigned components` }, category.component_count) : null);
  if (!category.children.length) return link;
  link.classList.add('branch-link'); link.firstChild.textContent = `View ${category.name}`;
  const branch = el('details', { 'data-branch-id': category.category_id }, el('summary', {}, category.name),
    el('div', { class: 'tree-branch' }, link, category.children.map(treeNode)));
  if (category.parent_category_id === null) branch.open = true;
  return branch;
}
async function loadSidebar() {
  const target = document.querySelector('#category-tree');
  try {
    const categories = await getCategories();
    target.replaceChildren(...categories.data.map(treeNode));
    document.querySelector('#category-count').textContent = categories.flat.length;
    markNavigation(window.location.pathname, activeCategoryId);
  } catch {
    const retry = el('button', { class: 'button', type: 'button' }, 'Retry');
    retry.addEventListener('click', loadSidebar);
    target.replaceChildren(el('p', { class: 'muted' }, 'Categories could not be loaded.'), retry);
  }
}
let activeCategoryId = null;
function markNavigation(path, categoryId) {
  activeCategoryId = categoryId;
  for (const link of document.querySelectorAll('[data-primary]')) {
    const active = link.dataset.primary === 'home' ? path === '/' : path === '/browse';
    if (active) link.setAttribute('aria-current', 'page'); else link.removeAttribute('aria-current');
  }
  for (const link of document.querySelectorAll('[data-category-id]')) {
    if (Number(link.dataset.categoryId) === categoryId) link.setAttribute('aria-current', 'page');
    else link.removeAttribute('aria-current');
  }
  if (categoriesPromise && categoryId) getCategories().then(({ flat }) => {
    const seen = new Set(); let row = flat.find(c => c.category_id === categoryId);
    while (row && !seen.has(row.category_id)) {
      seen.add(row.category_id);
      const branch = document.querySelector(`[data-branch-id="${row.category_id}"]`);
      if (branch) branch.open = true;
      row = flat.find(c => c.category_id === row.parent_category_id);
    }
  }).catch(() => {});
}
async function home(signal) {
  const [{ data: stats }, categories, newest] = await Promise.all([
    api.stats(signal), getCategories(), api.components({ limit: 6, sort: 'id_desc' }, signal),
  ]);
  const node = el('div', {}, breadcrumb(),
    el('section', { class: 'hero' }, el('p', { class: 'eyebrow' }, el('span', { class: 'status-dot', 'aria-hidden': 'true' }), 'YOUR ELECTRONICS KNOWLEDGE BASE'),
      el('h1', {}, 'Understand the components.', el('br'), el('span', { class: 'accent' }, 'Build the bigger picture.')),
      el('p', { class: 'lead' }, 'Explore electronic components and circuits through working principles, technical tables, diagrams, and specifications.'),
      el('form', { class: 'hero-search search-form', action: '/search', role: 'search' },
        el('label', { class: 'sr-only', for: 'hero-search-input' }, 'Search components'),
        el('input', { id: 'hero-search-input', name: 'q', type: 'search', maxlength: '200', placeholder: 'What do you want to understand?' }),
        el('button', { class: 'button primary', type: 'submit' }, 'Explore the library →'))));
  node.append(el('div', { class: 'stats', 'aria-label': 'Live catalogue statistics' },
    [['components', 'Component entries'], ['categories', 'Categories'], ['content_types', 'Content formats & types'], ['tags', 'Discoverable tags']].map(([key, label]) =>
      el('div', { class: 'stat' }, el('span', { class: 'stat-number' }, Number(stats[key]).toLocaleString()), el('span', { class: 'stat-label' }, label)))));
  node.append(sectionHead('Start with a category'), categories.data.length ? grid(categories.data, categoryCard) : empty('No categories yet', 'The catalogue has not been populated.'));
  // A single catalogue root is common; surface its children without assuming fixed depth.
  if (categories.data.length === 1 && categories.data[0].children.length) {
    node.append(sectionHead('Explore the library'), grid(categories.data[0].children, categoryCard));
  }
  if (newest.data.length) node.append(sectionHead('Newest catalogue entries', '/browse?sort=id_desc'), grid(newest.data, componentCard));
  node.append(el('p', { class: 'accuracy-note' }, 'Catalogue ordering uses component IDs, not publication dates. Content is educational; diagrams appear only when their referenced assets are available.'));
  return { node, title: 'ElectroDB — Electronics reference', categoryId: null };
}
async function categoryPage(id, url, signal) {
  const [{ data: category }, result] = await Promise.all([
    api.category(id, signal), api.components({ category_id: id, page: url.searchParams.get('page') || '1', limit: 12 }, signal),
  ]);
  const parents = category.breadcrumbs.slice(0, -1);
  const node = el('div', {}, breadcrumb(parents, category.name),
    el('header', { class: 'page-intro' }, el('p', { class: 'eyebrow' }, 'CATEGORY DIRECTORY'), el('h1', {}, category.name),
      category.description ? el('p', {}, category.description) : null));
  if (category.children.length) node.append(sectionHead('Subcategories'), grid(category.children, categoryCard));
  if (result.pagination.total) {
    node.append(sectionHead('Components'), el('p', { class: 'result-summary' }, `${result.pagination.total} entries directly assigned to this category.`),
      result.data.length ? grid(result.data, componentCard) : empty('No entries on this page', 'Choose an earlier page to view components.'),
      pagination(result.pagination, url));
  } else if (!category.children.length) node.append(empty('This category is empty', 'No subcategories or component entries have been added yet.'));
  rememberList(url);
  return { node, title: `${category.name} — ElectroDB`, categoryId: category.category_id };
}
function filterForm(url, categories, tags) {
  const form = el('form', { class: 'filters', 'aria-label': 'Filter components' });
  const textInput = el('input', { id: 'filter-query', name: 'q', type: 'search', maxlength: '200', value: url.searchParams.get('q') || '', placeholder: 'Name or description' });
  form.append(el('div', { class: 'filter-field' }, el('label', { for: 'filter-query' }, 'Search'), textInput));
  function selectField(id, label, name, options, initial) {
    const select = el('select', { id, name }, options.map(([value, text]) => el('option', { value }, text)));
    select.value = initial;
    return el('div', { class: 'filter-field' }, el('label', { for: id }, label), select);
  }
  form.append(selectField('filter-category', 'Category (includes descendants)', 'category_id',
    [['', 'All categories'], ...categories.flat.map(c => [String(c.category_id), c.name])], url.searchParams.get('category_id') || ''));
  form.append(selectField('filter-tag', 'Tag', 'tag_id', [['', 'Any tag'], ...tags.data.filter(t => t.component_count > 0).map(t => [String(t.tag_id), t.tag_name])], url.searchParams.get('tag_id') || ''));
  form.append(selectField('filter-sort', 'Sort by', 'sort', [['name_asc', 'Name: A–Z'], ['name_desc', 'Name: Z–A'], ['id_desc', 'Highest ID first']], url.searchParams.get('sort') || 'name_asc'));
  form.append(el('button', { class: 'button primary', type: 'submit' }, 'Apply'));
  form.addEventListener('submit', event => {
    event.preventDefault(); const next = new URL(url); next.search = '';
    for (const [key, value] of new FormData(form)) if (String(value).trim()) next.searchParams.set(key, String(value).trim());
    if (next.searchParams.has('category_id')) next.searchParams.set('include_descendants', 'true');
    navigate(next.pathname + next.search);
  });
  return form;
}
async function resultsPage(url, signal) {
  const params = Object.fromEntries(url.searchParams); params.limit = 12;
  // Ignore internal UI parameters; supported filter values are validated server-side.
  if (params.category_id) params.include_descendants = 'true';
  const [result, categories, tags] = await Promise.all([api.components(params, signal), getCategories(), getTags()]);
  const q = url.searchParams.get('q')?.trim() || '';
  const search = url.pathname === '/search';
  const heading = search ? (q ? `Results for “${q}”` : 'Search the library') : 'All components';
  const node = el('div', {}, breadcrumb([], search ? 'Search' : 'All components'),
    el('header', { class: 'page-intro' }, el('p', { class: 'eyebrow' }, 'EXPLORE & DISCOVER'), el('h1', {}, heading),
      el('p', {}, 'Find entries by name or description. Narrow the library by category or tag.')),
    filterForm(url, categories, tags));
  const p = result.pagination;
  node.append(el('div', { class: 'section-head' }, el('h2', {}, 'Component library'),
    el('p', { class: 'result-summary' }, p.total ? `${result.data.length ? (p.page - 1) * p.limit + 1 : 0}–${result.data.length ? (p.page - 1) * p.limit + result.data.length : 0} of ${p.total} results` : '0 results')));
  node.append(result.data.length ? grid(result.data, componentCard) : empty('No components found', 'Try a different term, remove a filter, or return to an earlier page.'), pagination(p, url));
  rememberList(url);
  return { node, title: `${search ? 'Search' : 'All components'} — ElectroDB`, categoryId: null };
}
async function detailPage(id, signal) {
  const { data: component } = await api.component(id, signal);
  const node = el('div', {}, breadcrumb(component.breadcrumbs, component.name), backLink(component.category_id));
  const header = el('header', { class: 'detail-header' },
    el('a', { class: 'pill', href: `/categories/${component.category_id}` }, component.category_name),
    el('h1', {}, component.name), component.short_description ? el('p', { class: 'lead' }, component.short_description) : null);
  if (component.tags.length) header.append(el('div', { class: 'tags', 'aria-label': 'Component tags' }, component.tags.map(tag =>
    el('a', { class: 'tag', href: `/browse?tag_id=${tag.tag_id}` }, `#${tag.tag_name}`))));
  node.append(header);
  const body = el('div', { class: 'detail-body' }); const toc = el('nav', { class: 'toc', 'aria-label': 'On this page' }, el('p', {}, 'ON THIS PAGE'));
  const sections = []; let count = 0;
  function add(title, content, key) {
    const anchor = key || `section-${++count}`;
    sections.push(el('section', { class: 'detail-section', id: anchor },
      el('h2', {}, el('span', { class: 'section-index', 'aria-hidden': 'true' }, String(sections.length + 1).padStart(2, '0')), title), content));
    toc.append(el('a', { href: `#${anchor}` }, title));
  }
  if (component.image_url || component.circuit_symbol_url) {
    body.append(el('div', { class: 'media-pair' }, component.image_url ? media(component.image_url, `${component.name} overview image`) : null,
      component.circuit_symbol_url ? media(component.circuit_symbol_url, `${component.name} circuit symbol`) : null));
  }
  if (component.description) add('Overview', el('p', { class: 'prose' }, component.description), 'overview');
  const workingContent = component.content.find(c => c.content_type_name === 'Working Principle' && c.data_format === 'TEXT');
  const principle = component.working_principle || workingContent?.content;
  if (principle) add('Working principle', el('p', { class: 'prose' }, principle), 'working-principle');
  for (const item of component.content) {
    if (item.content_type_name === 'Working Principle' && item.data_format === 'TEXT' && item.content.trim() === principle?.trim()) continue;
    if (item.data_format === 'IMAGE' && item.content.trim() === component.circuit_symbol_url?.trim()) continue;
    add(item.title || item.content_type_name, renderContent(item), `content-${item.content_id}`);
  }
  if (component.specifications.length) {
    add('Specifications', dataTable(component.specifications.map(s => ({ Specification: s.name, Value: s.value, Unit: s.unit || '—' })), 'Available specifications. Values may be illustrative.'), 'specifications');
  }
  body.append(...sections);
  body.append(el('p', { class: 'accuracy-note' }, 'Educational reference only. Some entries describe generic devices or circuit configurations, not a specific manufacturer part. Missing optional sections are omitted; stored values and technical tables are shown without alteration.'));
  node.append(el('div', { class: 'detail-layout' }, body, toc));
  if (component.related.length) node.append(sectionHead('More in this category', `/categories/${component.category_id}`), grid(component.related, componentCard));
  if (component.missing_required_content.length) console.debug('Missing configured content sections:', component.missing_required_content.map(c => c.name));
  return { node, title: `${component.name} — ElectroDB`, categoryId: component.category_id };
}
function errorPage(error) {
  const notFound = error.status === 404;
  const retry = el('button', { class: 'button primary', type: 'button' }, 'Try again');
  retry.addEventListener('click', () => renderRoute(false));
  return el('section', { class: 'error-state', role: 'alert' },
    el('h1', {}, notFound ? 'Entry not found' : 'Could not load this page'),
    el('p', {}, notFound ? 'This entry does not exist or has been removed from the catalogue.' : error.message),
    notFound ? null : retry, el('a', { class: 'button', href: '/' }, 'Back to home'));
}
async function renderRoute(focus = true) {
  const version = ++routeVersion;
  controller?.abort(); controller = new AbortController(); const signal = controller.signal;
  const url = new URL(window.location.href);
  main.setAttribute('aria-busy', 'true');
  main.replaceChildren(el('div', { class: 'loader', role: 'status' }, el('span', { class: 'spinner', 'aria-hidden': 'true' }), 'Loading catalogue…'));
  try {
    let page; let match;
    if (url.pathname === '/') page = await home(signal);
    else if ((match = url.pathname.match(/^\/categories\/([^/]+)\/?$/))) page = await categoryPage(match[1], url, signal);
    else if ((match = url.pathname.match(/^\/components\/([^/]+)\/?$/))) page = await detailPage(match[1], signal);
    else if (['/search', '/browse'].includes(url.pathname)) page = await resultsPage(url, signal);
    else { const error = new Error('Page not found'); error.status = 404; throw error; }
    if (version !== routeVersion) return;
    main.replaceChildren(page.node); document.title = page.title;
    markNavigation(url.pathname, page.categoryId);
  } catch (error) {
    if (error.name === 'AbortError' || version !== routeVersion) return;
    main.replaceChildren(errorPage(error)); document.title = 'ElectroDB — Page unavailable';
    markNavigation(url.pathname, null);
  } finally {
    if (version === routeVersion) {
      main.removeAttribute('aria-busy');
      document.querySelector('#global-search').value = url.searchParams.get('q') || '';
      if (focus) main.focus({ preventScroll: true });
      if (url.hash) {
        try { document.getElementById(decodeURIComponent(url.hash.slice(1)))?.scrollIntoView(); }
        catch { /* Ignore malformed URL fragments. */ }
      }
    }
  }
}
function navigate(path) {
  history.pushState({}, '', path); closeMenu(); window.scrollTo({ top: 0, behavior: 'instant' }); renderRoute();
}
document.addEventListener('click', event => {
  if (event.button !== 0 || event.metaKey || event.ctrlKey || event.shiftKey || event.altKey || event.defaultPrevented) return;
  const link = event.target.closest('a[href]');
  if (!link || link.target === '_blank' || link.hasAttribute('download')) return;
  const url = new URL(link.href);
  if (url.origin !== location.origin || url.hash || !/^\/(?:$|browse$|search$|categories\/[^/]+\/?$|components\/[^/]+\/?$)/.test(url.pathname)) return;
  event.preventDefault(); navigate(url.pathname + url.search);
});
document.addEventListener('submit', event => {
  const form = event.target;
  if (!form.matches('.search-form')) return;
  event.preventDefault(); const query = String(new FormData(form).get('q') || '').trim();
  navigate(`/search${query ? `?q=${encodeURIComponent(query)}` : ''}`);
});
window.addEventListener('popstate', () => { closeMenu(); renderRoute(); });
loadSidebar(); renderRoute(false);
