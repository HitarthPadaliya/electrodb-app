import test from 'node:test';
import assert from 'node:assert/strict';
import { positiveInteger, paging, searchTerm, likePattern, descendants, breadcrumbs, categoryTree, normalizeContent } from '../src/utils.js';
import { safeResource, tableHeaders, headerLabel } from '../public/js/render.js';
const categories = [
  { category_id: 1, parent_category_id: null, name: 'Root' },
  { category_id: 2, parent_category_id: 1, name: 'Child' },
  { category_id: 3, parent_category_id: 2, name: 'Leaf' },
  { category_id: 4, parent_category_id: null, name: 'Other root' },
];
test('Positive IDs and defaults', () => {
  assert.equal(positiveInteger('42'), 42); assert.equal(positiveInteger(undefined, 'page', 1), 1);
});
for (const invalid of ['0', '-1', '1.5', '1 OR 1=1', '01', '2147483648', ['1'], {}, '']) {
  test(`Reject invalid ID: ${JSON.stringify(invalid)}`, () => assert.throws(() => positiveInteger(invalid), { status: 400 }));
}
test('Bounded pagination', () => {
  assert.deepEqual(paging({}), { page: 1, limit: 12, offset: 0 });
  assert.deepEqual(paging({ page: '3', limit: '20' }), { page: 3, limit: 20, offset: 40 });
  assert.throws(() => paging({ limit: '101' })); assert.throws(() => paging({ page: '1000001' }));
});
test('Search input shape and length validation', () => {
  assert.equal(searchTerm('  AND  '), 'AND'); assert.equal(searchTerm(undefined), '');
  assert.throws(() => searchTerm(['x'])); assert.throws(() => searchTerm('a'.repeat(201)));
});
test('Escape SQL wildcard characters literally', () => assert.equal(likePattern('a%_!'), '%a!%!_!!%'));
test('Arbitrary-depth trees and breadcrumbs', () => {
  assert.deepEqual(descendants(categories, 1).sort(), [1, 2, 3]);
  assert.deepEqual(breadcrumbs(categories, 3).map(x => x.category_id), [1, 2, 3]);
  const tree = categoryTree(categories);
  assert.equal(tree.length, 2); assert.equal(tree[0].children[0].children[0].category_id, 3);
  assert.deepEqual(breadcrumbs(categories, 99), []);
});
test('Malformed cycles never produce circular JSON or infinite loops', () => {
  const cyclic = [{ category_id: 1, parent_category_id: 2 }, { category_id: 2, parent_category_id: 1 }];
  assert.doesNotThrow(() => JSON.stringify(categoryTree(cyclic)));
  assert.equal(breadcrumbs(cyclic, 1).length, 2); assert.equal(descendants(cyclic, 1).length, 2);
});
test('Orphan category remains navigable', () => assert.equal(categoryTree([{ category_id: 1, parent_category_id: 99 }]).length, 1));
test('TABLE JSON preserves binary strings and accepts scalar records', () => {
  const content = '[{"current":"0000","next":"0001","X":null}]';
  const data = normalizeContent({ data_format: 'TABLE', content });
  assert.equal(data.table_data[0].current, '0000'); assert.equal(data.parse_error, null);
});
for (const invalid of ['broken', '{"A":1}', '[[1]]', '[null]', '[{"A":{"nested":1}}]']) {
  test(`Invalid table gracefully falls back: ${invalid}`, () => {
    const data = normalizeContent({ data_format: 'TABLE', content: invalid });
    assert.equal(data.table_data, null); assert.ok(data.parse_error); assert.equal(data.content, invalid);
  });
}
test('Do not parse equations, text, or media as JSON', () => {
  for (const format of ['EQUATION','TEXT','IMAGE','DIAGRAM','GRAPH','TIMING_DIAGRAM','DOCUMENT']) {
    const data = normalizeContent({ data_format: format, content: '[{"x":1}]' });
    assert.equal(data.table_data, null); assert.equal(data.parse_error, null);
  }
});
test('Resource policy blocks executable links, remote HTTP and credentials', () => {
  const origin = 'http://localhost:3000';
  assert.equal(safeResource('/images/a.svg', origin), `${origin}/images/a.svg`);
  assert.equal(safeResource('https://example.com/a.pdf', origin), 'https://example.com/a.pdf');
  for (const bad of ['javascript:alert(1)','data:text/html,test','http://example.com/a.svg','https://user:pass@example.com/a','']) {
    assert.equal(safeResource(bad, origin), null);
  }
});
test('Table column union does not lose sparse fields', () => {
  assert.deepEqual(tableHeaders([{ A: 0 }, { A: 1, B: 0 }]), ['A', 'B']);
  assert.equal(headerLabel('Q_next'), 'Q (next)'); assert.equal(headerLabel('S1'), 'S1');
});
