import test from 'node:test';
import assert from 'node:assert/strict';
import { catalogue } from '../src/catalogue.js';
function fakePool(handler) {
  const calls = [];
  return { calls, execute: async (sql, params = []) => {
    const normalized = sql.replace(/\s+/g, ' ').trim(); calls.push({ sql: normalized, params });
    return [await handler(normalized, params), []];
  } };
}
test('Search and tags use parameter bindings; sort and pagination stay allowlisted', async () => {
  const pool = fakePool(sql => sql.startsWith('SELECT COUNT(*)') ? [{ total: 1 }] : [{ component_id: 1 }]);
  const result = await catalogue(pool).list({ q: "' OR 1=1 --", tag_id: '7', page: '2', limit: '10', sort: 'name_desc' });
  assert.equal(result.pagination.offset, undefined); assert.equal(result.pagination.total, 1);
  const final = pool.calls.at(-1);
  assert.ok(!final.sql.includes("' OR 1=1 --")); assert.ok(final.params.includes("%' OR 1=1 --%"));
  assert.ok(final.sql.includes('EXISTS')); assert.ok(final.sql.endsWith('LIMIT 10 OFFSET 10'));
  assert.ok(final.sql.includes('p.name DESC'));
});
test('SQL-injection-like sort values are rejected', async () => {
  const pool = fakePool(() => []);
  await assert.rejects(catalogue(pool).list({ sort: 'name_asc; DROP TABLE components' }), { status: 400 });
  assert.equal(pool.calls.length, 0);
});
test('Category filters expand descendants only when explicitly requested', async () => {
  const pool = fakePool(sql => {
    if (sql.startsWith('SELECT c.category_id')) return [
      { category_id: 1, parent_category_id: null }, { category_id: 2, parent_category_id: 1 },
      { category_id: 3, parent_category_id: 2 },
    ];
    return sql.startsWith('SELECT COUNT(*)') ? [{ total: 0 }] : [];
  });
  await catalogue(pool).list({ category_id: '1', include_descendants: 'true' });
  assert.deepEqual(pool.calls.at(-1).params.sort(), [1,2,3]);
  await catalogue(pool).list({ category_id: '1' }); assert.deepEqual(pool.calls.at(-1).params, [1]);
});
test('Unknown category returns 404 rather than all components', async () => {
  const pool = fakePool(() => []);
  await assert.rejects(catalogue(pool).list({ category_id: '99' }), { status: 404 });
});
test('Unknown component returns 404', async () => {
  const pool = fakePool(() => []);
  await assert.rejects(catalogue(pool).component('99'), { status: 404 });
});
test('Component detail joins content, specs, tags, template and related entries', async () => {
  const pool = fakePool(sql => {
    if (sql.startsWith('SELECT p.*, c.name')) return [{ component_id: 1, category_id: 2, name: 'Test', working_principle: 'Stored principle' }];
    if (sql.startsWith('SELECT c.category_id')) return [{ category_id: 2, parent_category_id: null, name: 'Category' }];
    if (sql.startsWith('SELECT cc.*')) return [{ content_id: 7, content_type_id: 5, data_format: 'TABLE', content: '[{"D":0,"Q_next":0}]' }];
    if (sql.startsWith('SELECT s.specification_id')) return [{ specification_id: 1, name: 'Bits', unit: 'bits', value: '1' }];
    if (sql.startsWith('SELECT t.tag_id')) return [{ tag_id: 2, tag_name: 'digital' }];
    if (sql.startsWith('SELECT ct.content_type_id')) return [
      { content_type_id: 5, name: 'Characteristic Table', is_required: 1 },
      { content_type_id: 15, name: 'Electrical Specifications', is_required: 1 },
      { content_type_id: 8, name: 'Timing Diagram', is_required: 1 },
    ];
    return [];
  });
  const { data } = await catalogue(pool).component('1');
  assert.equal(data.content[0].table_data[0].D, 0); assert.equal(data.tags[0].tag_name, 'digital');
  assert.equal(data.specifications.length, 1); assert.deepEqual(data.missing_required_content.map(x => x.content_type_id), [8]);
  assert.equal(data.breadcrumbs[0].name, 'Category');
});
