const base = (process.env.SMOKE_URL || 'http://127.0.0.1:3000').replace(/\/$/, '');
async function get(path, expected = 200) {
  const res = await fetch(base + path);
  if (res.status !== expected) throw new Error(`${path}: expected ${expected}, got ${res.status}`);
  return res.json();
}
try {
  await get('/api/health');
  const { data: stats } = await get('/api/stats');
  const categories = await get('/api/categories');
  const listing = await get('/api/components?limit=2');
  if (!Array.isArray(categories.data) || !Array.isArray(categories.flat) || !Array.isArray(listing.data)) throw new Error('Invalid response shape');
  if (categories.flat.length) {
    await get(`/api/categories/${categories.flat[0].category_id}`);
  }
  if (listing.data.length) {
    const { data } = await get(`/api/components/${listing.data[0].component_id}`);
    if (!Array.isArray(data.content) || !Array.isArray(data.specifications)) throw new Error('Invalid component detail');
  }
  await get('/api/search?q=gate&limit=5'); await get('/api/tags'); await get('/api/content-types'); await get('/api/specifications');
  await get('/api/components/2147483647',404); await get('/api/components/0',400);
  await get('/api/components?sort=invalid',400); await get('/api/missing',404);
  const html = await fetch(base + '/browse');
  if (!html.ok || !(await html.text()).includes('id="main"')) throw new Error('Frontend deep-link serving failed');
  console.log('Live API smoke checks passed.', stats);
} catch (error) { console.error(error.message); process.exitCode = 1; }
