export class ApiError extends Error {
  constructor(message, status) { super(message); this.status = status; }
}
export async function request(path, params = {}, signal) {
  const base = window.ELECTRODB_CONFIG?.apiBase || '/api';
  const url = new URL(`${base.replace(/\/$/, '')}/${path.replace(/^\//, '')}`, window.location.origin);
  for (const [key, value] of Object.entries(params)) {
    if (value !== undefined && value !== null && value !== '') url.searchParams.set(key, String(value));
  }
  let response;
  try { response = await fetch(url, { signal, headers: { Accept: 'application/json' } }); }
  catch (error) {
    if (error.name === 'AbortError') throw error;
    throw new ApiError('Cannot reach the server. Check your connection and try again.', 0);
  }
  let body;
  try { body = await response.json(); }
  catch { throw new ApiError('The server returned an unexpected response.', response.status); }
  if (!response.ok) throw new ApiError(body.error?.message || 'The request failed. Please try again.', response.status);
  return body;
}
export const api = {
  categories: signal => request('categories', {}, signal),
  category: (id, signal) => request(`categories/${encodeURIComponent(id)}`, {}, signal),
  components: (params, signal) => request('components', params, signal),
  component: (id, signal) => request(`components/${encodeURIComponent(id)}`, {}, signal),
  stats: signal => request('stats', {}, signal),
  tags: signal => request('tags', {}, signal),
};
