import express from 'express';
import helmet from 'helmet';
import rateLimit from 'express-rate-limit';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { catalogue } from './catalogue.js';
import { HttpError } from './utils.js';
const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
export function createApp(pool, config) {
  const app = express(); const service = catalogue(pool);
  app.disable('x-powered-by');
  app.set('query parser', 'simple');
  app.use(helmet({
    contentSecurityPolicy: { directives: {
      defaultSrc: ["'self'"], scriptSrc: ["'self'"],
      styleSrc: ["'self'", "'unsafe-inline'"], imgSrc: ["'self'", 'https:'],
      fontSrc: ["'self'"], connectSrc: ["'self'"], objectSrc: ["'none'"],
      baseUri: ["'self'"], formAction: ["'self'"],
      upgradeInsecureRequests: config.production ? [] : null,
    } },
    strictTransportSecurity: config.production ? undefined : false,
  }));
  app.get('/config.js', (req, res) => {
    res.set('Cache-Control', 'no-store').type('application/javascript').send(
      `window.ELECTRODB_CONFIG=${JSON.stringify({ apiBase: config.apiBase }).replace(/</g, '\\u003c')};`);
  });
  const api = express.Router();
  api.use(rateLimit({ windowMs: 60 * 1000, limit: 120, standardHeaders: 'draft-7', legacyHeaders: false,
    message: { error: { message: 'Too many requests. Please try again shortly.' } } }));
  api.use((req, res, next) => { res.set('Cache-Control', 'no-store'); next(); });
  api.get('/health', async (req, res) => {
    try { await pool.execute('SELECT 1'); res.json({ status: 'ok', database: 'connected' }); }
    catch { res.status(503).json({ status: 'error', database: 'unavailable' }); }
  });
  api.get('/stats', async (req, res) => res.json(await service.stats()));
  api.get('/categories', async (req, res) => res.json(await service.categories()));
  api.get('/categories/:categoryId', async (req, res) => res.json(await service.category(req.params.categoryId)));
  api.get('/components', async (req, res) => res.json(await service.list(req.query)));
  api.get('/search', async (req, res) => res.json(await service.list(req.query)));
  api.get('/components/:componentId', async (req, res) => res.json(await service.component(req.params.componentId)));
  api.get('/tags', async (req, res) => res.json(await service.tags()));
  api.get('/content-types', async (req, res) => res.json(await service.contentTypes()));
  api.get('/specifications', async (req, res) => res.json(await service.specifications()));
  api.use((req, res, next) => next(new HttpError(404, 'API endpoint not found')));
  app.use('/api', api);
  app.use('/vendor/katex', express.static(path.join(root, 'node_modules/katex/dist'), { maxAge: '1d', index: false }));
  app.use(express.static(path.join(root, 'public'), { index: false, maxAge: config.production ? '1h' : 0 }));
  app.get(['/', '/categories/:categoryId', '/components/:componentId', '/search', '/browse'],
    (req, res) => res.set('Cache-Control', 'no-cache').sendFile(path.join(root, 'public/index.html')));
  app.use((req, res) => res.status(404).type('text').send('Not found'));
  app.use((err, req, res, next) => {
    if (res.headersSent) return next(err);
    const status = err.status || 500;
    if (status >= 500) console.error('Request failed:', err.code || err.message);
    res.status(status).json({ error: { message: status >= 500 ?
      'The catalogue is temporarily unavailable. Please try again later.' : err.message } });
  });
  return app;
}
