-- Run as a database administrator AFTER importing electrodb.sql.
-- Change the password before executing; this file is not run automatically.
CREATE USER IF NOT EXISTS 'electrodb_reader'@'127.0.0.1'
  IDENTIFIED BY 'replace_with_your_password';
GRANT SELECT ON electrodb.* TO 'electrodb_reader'@'127.0.0.1';
-- For DB_HOST=localhost, create/grant the matching @localhost account instead.
