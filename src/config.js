import 'dotenv/config';
function integer(name, fallback, min, max) {
  const raw = process.env[name] ?? String(fallback);
  if (!/^\d+$/.test(raw) || Number(raw) < min || Number(raw) > max) {
    throw new Error(`${name} must be an integer between ${min} and ${max}`);
  }
  return Number(raw);
}
export const config = {
  production: process.env.NODE_ENV === 'production',
  host: process.env.HOST || '127.0.0.1',
  port: integer('PORT', 3000, 1, 65535),
  apiBase: process.env.PUBLIC_API_BASE_URL || '/api',
  database: {
    host: process.env.DB_HOST || '127.0.0.1',
    port: integer('DB_PORT', 3306, 1, 65535),
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || '',
    database: process.env.DB_NAME || 'electrodb',
    connectionLimit: integer('DB_CONNECTION_LIMIT', 10, 1, 100),
    waitForConnections: true,
    queueLimit: 100,
    connectTimeout: 10000,
    charset: 'utf8mb4',
    multipleStatements: false,
    enableKeepAlive: true,
  },
};
