import { createApp } from './app.js';
import { pool } from './db.js';
import { config } from './config.js';
try {
  await pool.execute('SELECT 1');
  const app = createApp(pool, config);
  const server = app.listen(config.port, config.host, () => {
    console.log(`ElectroDB is running at http://${config.host}:${config.port}`);
  });
  server.on('error', async error => { console.error('Server failed:', error.message); await pool.end(); process.exit(1); });
  let closing = false;
  async function shutdown() {
    if (closing) return; closing = true;
    const timeout = setTimeout(() => process.exit(1), 10000); timeout.unref();
    server.close(async () => {
      await pool.end(); clearTimeout(timeout); process.exit(0);
    });
  }
  process.on('SIGINT', shutdown); process.on('SIGTERM', shutdown);
} catch (error) {
  console.error('Database connection failed:', error.code || error.message);
  console.error('Check .env, start MySQL/MariaDB, and import database/electrodb.sql.');
  await pool.end(); process.exit(1);
}
