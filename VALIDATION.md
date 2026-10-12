# Validation performed

## Completed in the generation environment

- All 15 JavaScript files passed `node --check` syntax validation.
- `node --test` passed all 39 unit tests with zero failures or skipped tests.
- The copied SQL dump matches the uploaded source byte-for-byte.
- The media manifest was derived from the source dump's unique image paths.

The tests cover input validation, pagination bounds, SQL binding/allowlisted
sorting, descendant filters, 404 handling, full detail assembly with a mocked
database adapter, cycle-safe category structures, content-type parsing,
resource URL safety, table column unions, API service errors, and rendering
fallbacks using a minimal DOM test double.

## Not performed here

- Dependency installation or resolution against the npm registry.
- SQL import or live execution against a MySQL/MariaDB server.
- Live Express/API integration or HTTP smoke checks.
- Real-browser visual, keyboard, screen-reader, or end-to-end testing.

Unit tests use mocked database responses and minimal DOM doubles. They are
not a claim of live database compatibility or a substitute for browser tests.

## Local acceptance checks

1. Run `npm install` and configure `.env`.
2. Import the SQL into an empty electrodb database, if not already imported.
3. Run `npm run check` to confirm all nine tables and inspect content gaps.
4. Run `npm start`; in another terminal, run `npm run smoke`.
5. Open home, category, search, and component-detail pages in a browser.
6. Reload a deep link, use browser back/forward, apply filters and pagination.
7. Try an unknown ID, no-result query, and missing diagram.
8. Check mobile layout, theme switching, keyboard navigation, and equation/table rendering.
9. Add verified diagrams and resolve the documented seed bit-label issues before publishing.
