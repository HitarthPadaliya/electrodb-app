import test from 'node:test';
import assert from 'node:assert/strict';
import { request } from '../public/js/api.js';
globalThis.window = { ELECTRODB_CONFIG: { apiBase: '/api/' }, location: { origin: 'http://localhost:3000' } };
test('API service builds same-origin URLs and encodes query parameters', async () => {
  let captured;
  globalThis.fetch = async url => { captured = url; return { ok: true, json: async () => ({ data: [] }) }; };
  await request('/components', { q: 'AND & OR', page: 2, omitted: '' });
  assert.equal(captured.pathname, '/api/components'); assert.equal(captured.searchParams.get('q'), 'AND & OR');
  assert.equal(captured.searchParams.get('page'), '2'); assert.equal(captured.searchParams.has('omitted'), false);
});
test('API service preserves server error messages and statuses', async () => {
  globalThis.fetch = async () => ({ ok: false, status: 404, json: async () => ({ error: { message: 'Component not found' } }) });
  await assert.rejects(request('components/99'), { message: 'Component not found', status: 404 });
});
test('API service translates malformed JSON and network failures', async () => {
  globalThis.fetch = async () => ({ status: 200, json: async () => { throw new Error('JSON parse'); } });
  await assert.rejects(request('categories'), { message: 'The server returned an unexpected response.' });
  globalThis.fetch = async () => { throw new TypeError('Network'); };
  await assert.rejects(request('categories'), { status: 0 });
});
