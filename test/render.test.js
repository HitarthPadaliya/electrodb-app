import test from 'node:test';
import assert from 'node:assert/strict';
import { el, renderContent, dataTable } from '../public/js/render.js';
class FakeNode {
  constructor(tag = '#text', text = '') { this.tag = tag; this.text = text; this.children = []; this.attributes = {}; this.className = ''; }
  setAttribute(key, value) { this.attributes[key] = value; }
  append(...children) { this.children.push(...children); }
  addEventListener() {}
  get textContent() { return this.text + this.children.map(x => x.textContent).join(''); }
  set textContent(value) { this.text = value; this.children = []; }
}
globalThis.Node = FakeNode;
globalThis.document = {
  createElement: tag => new FakeNode(tag), createTextNode: text => new FakeNode('#text', text),
};
globalThis.window = { location: { origin: 'http://localhost:3000' } };
test('Untrusted database text is appended as text, not executable HTML', () => {
  const attack = '<img src=x onerror=alert(1)>';
  const node = el('p', {}, attack);
  assert.equal(node.children[0].tag, '#text'); assert.equal(node.textContent, attack);
});
test('Every stored format has a safe rendering path', () => {
  for (const format of ['TEXT','EQUATION','IMAGE','DIAGRAM','GRAPH','TIMING_DIAGRAM','DOCUMENT','UNKNOWN']) {
    const node = renderContent({ data_format: format, content: '/images/test.svg', title: 'Test' });
    assert.ok(node instanceof FakeNode);
  }
  const table = renderContent({ data_format: 'TABLE', table_data: [{ A: 0, B: 1 }], title: 'Truth table' });
  assert.ok(table.textContent.includes('Truth table'));
});
test('Malformed table content gets a fallback with the original text', () => {
  const node = renderContent({ data_format: 'TABLE', content: '{broken' });
  assert.ok(node.textContent.includes('could not be formatted')); assert.ok(node.textContent.includes('{broken'));
});
test('Empty tables, sparse cells, and X notes render without errors', () => {
  assert.ok(dataTable([], 'Empty').textContent.includes('No rows'));
  const node = dataTable([{ A: 0 }, { B: 'X' }], 'Sparse', true);
  assert.ok(node.textContent.includes('—')); assert.ok(node.textContent.includes('don’t care'));
});
test('Executable document URLs are not made clickable', () => {
  const node = renderContent({ data_format: 'DOCUMENT', content: 'javascript:alert(1)' });
  assert.equal(node.tag, 'p'); assert.ok(node.textContent.includes('No valid document'));
});
