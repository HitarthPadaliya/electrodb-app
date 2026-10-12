# ElectroDB

A database-driven electronic-components reference website built with Node.js,
Express 5, mysql2, and plain HTML/CSS/JavaScript. Express serves the API and
frontend on the same origin. No React, bundler, login, shopping cart, or admin
editing interface is required.

This implementation is based on the attached `electrodb-3.sql` and the
project's `frontend_design_requirements.md`. The supplied SQL is included
unchanged as `database/electrodb.sql`. No schema migrations are necessary.

## Features

- Responsive dark/light interface, with a persistent theme preference.
- Database-driven category tree supporting arbitrary depth.
- Category breadcrumbs, child categories, and directly assigned components.
- Name/short-description/description search with literal wildcard escaping.
- Category/descendant and tag filtering, allowlisted sorting, pagination.
- ID-based detail routes; slug is returned but not used as a route identifier.
- Component description, working principle, main image, circuit symbol,
  configured technical sections, specifications with units, and tags.
- Related entries from the same assigned category.
- Per-format rendering for all eight content formats in the schema.
- Local KaTeX equation rendering with plain-text fallback; no CDN dependency.
- Invalid table JSON, unavailable media, empty states, errors, and 404 states.
- A reusable frontend API module and History API navigation with deep links.
- SELECT-only API, parameterized SQL, bounded pagination, security headers,
  API rate limiting, connection pooling, and graceful shutdown.
- Database diagnostics, live HTTP smoke checks, and dependency-free unit tests.

All catalogue names and educational content come from the database/API.
The frontend does not embed a replacement catalogue.

## Requirements

- Node.js 20 or newer, with npm.
- A running MySQL or MariaDB server. The original export identifies
  MariaDB 10.4.32; the application uses MySQL-compatible queries through mysql2.
- A modern browser with JavaScript enabled.
- Internet access during `npm install` to install the declared dependencies.
  Subsequent frontend use requires no third-party script/CDN.

The exact dependency resolution is determined on first installation. Commit
the resulting package-lock.json for your deployment and use `npm ci` thereafter.
This archive does not include node_modules or a generated lockfile.

## Quick start

Open a terminal in the extracted `electrodb-app` directory.

### 1. Install dependencies

```bash
npm install
cp .env.example .env
```

On Windows PowerShell, use `Copy-Item .env.example .env` instead of `cp`.

### 2. Create and import the database

Using a database administrator account:

```bash
mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS electrodb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
mysql -u root -p electrodb < database/electrodb.sql
```

Use the MariaDB `mariadb` command instead of `mysql` if appropriate for your
installation. Shell input redirection is supported in bash and cmd.exe; in
PowerShell, open the database client and execute the following instead:

```sql
CREATE DATABASE IF NOT EXISTS electrodb
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE electrodb;
SOURCE database/electrodb.sql;
```

Run `SOURCE` from the project directory, or supply the full local file path.
Alternatively, import the dump into the selected `electrodb` database using
phpMyAdmin. The dump does not create/select the database by itself.

Import into an empty database, or skip this step if you have already imported
the same dump. Re-importing it into existing tables will cause table/key
conflicts. Import is an administrator step; the application never auto-imports
or changes your database.

### 3. Configure database credentials

For the read-only website, create a SELECT-only account. Edit the password in
`database/create-reader.example.sql` first, then execute the file as an admin:

```bash
mysql -u root -p < database/create-reader.example.sql
```

Update `.env` to match:

```dotenv
NODE_ENV=development
HOST=127.0.0.1
PORT=3000
DB_HOST=127.0.0.1
DB_PORT=3306
DB_USER=electrodb_reader
DB_PASSWORD=your_actual_password
DB_NAME=electrodb
DB_CONNECTION_LIMIT=10
PUBLIC_API_BASE_URL=/api
```

If you already have a suitable database account, use its credentials instead.
The SQL user host and DB_HOST must correspond to your environment. For
`DB_HOST=localhost`, use the corresponding `@localhost` user/grant. Never
commit `.env` or expose database credentials to frontend code.

### 4. Check and start

```bash
npm run check
npm start
```

Open `http://127.0.0.1:3000` in your browser. Do not open `index.html` directly
as a file and do not use a separate frontend development server; Express serves
both the frontend and its API. Use `npm run dev` for Node's restart-on-change
watch mode.

From a second terminal, with the server running:

```bash
npm run smoke
```

Run the unit tests at any time, including before installing dependencies:

```bash
node --test
# After installation, the equivalent npm shortcut is:
npm test
```

## Pages

| Route | Purpose |
| --- | --- |
| `/` | Purpose statement, search, root categories, live stats, highest-ID entries |
| `/browse` | Paginated component directory with search/filter/sort controls |
| `/categories/:categoryId` | Category, ancestor breadcrumbs, children, directly assigned components |
| `/search?q=...` | Search results and additional filters |
| `/components/:componentId` | Component educational content, specifications, and related entries |

“Newest” means highest component ID, not a publication timestamp: the schema
contains no created_at field. Card/sidebar component counts represent direct
assignments, not the total of descendants.

## REST API

All routes are GET-only. Success responses use `data`, with `pagination` where
applicable. Errors use `{ "error": { "message": "..." } }`. `/api/health` has a
small independent status response.

| Endpoint | Response |
| --- | --- |
| `/api/health` | `status` and database availability; 503 when unavailable |
| `/api/stats` | Current component/category/content-type/tag counts |
| `/api/categories` | Category tree in `data`, flat category records in `flat` |
| `/api/categories/:id` | Category, breadcrumbs, child categories, content template |
| `/api/components` | Paginated component summaries |
| `/api/search` | Alias of component listing/search |
| `/api/components/:id` | Full component, breadcrumbs, content, specs, tags, template, missing-content diagnostics, related entries |
| `/api/tags` | Tags and direct component counts |
| `/api/content-types` | Content-type definitions |
| `/api/specifications` | Specification definitions and units |

### Listing/search query parameters

| Parameter | Meaning |
| --- | --- |
| `q` | Search name, short description, and description; at most 200 characters |
| `category_id` | Positive database ID; defaults to direct assignments |
| `include_descendants` | `true`/`false` when filtering by category |
| `tag_id` | Positive tag ID |
| `sort` | `name_asc` (default), `name_desc`, or `id_desc` |
| `page` | Positive page number; defaults to 1 |
| `limit` | 1–100 entries; defaults to 12 |

The UI fixes the page size at 12 and includes descendants when a category is
selected in the browse/search filter. A category detail page intentionally
shows direct assignments, and child categories separately.

Examples:

```text
/api/components?q=counter&page=1&limit=12
/api/components?category_id=2&include_descendants=true
/api/components?tag_id=30&sort=name_asc
/api/components/7
```

List response shape:

```json
{
  "data": [
    {
      "component_id": 7,
      "category_id": 5,
      "name": "JK Flip-Flop",
      "slug": "jk-flip-flop",
      "short_description": "A one-bit storage element with hold, set, reset, and toggle operations.",
      "image_url": "/images/flip-flops/jk.svg",
      "category_name": "Flip-Flops"
    }
  ],
  "pagination": { "page": 1, "limit": 12, "total": 1, "pages": 1 }
}
```

The JSON above is a shape illustration; actual totals depend on the request.
Invalid parameters receive 400, absent category/component records receive 404,
and unexpected database failures receive a generic 500 response. Query syntax
is never taken from arbitrary sort names; sort expressions are allowlisted.

## Content rendering and ordering

`component_content.content` is LONGTEXT, not uniformly JSON.

- TEXT: text-only DOM rendering with preserved line breaks; no executable HTML.
- TABLE: the backend parses only arrays of objects containing scalar values.
  It returns `table_data` and `parse_error`; invalid data remains readable as
  raw text without preventing the rest of the page from rendering.
- EQUATION: KaTeX with `trust: false`, expansion/size limits, and plain-text
  fallback when unavailable.
- IMAGE, DIAGRAM, TIMING_DIAGRAM, GRAPH: use the stored image path. The current
  schema does not define a structured graph-series contract, so the app does
  not invent graph data or numerical simulations.
- DOCUMENT: a safe open/view link rather than an embedded document viewer.

For technical sections, ordering uses category_content_types.display_order
when the category configures that content type, otherwise the component's
own display_order; ties use component order and content_id. General overview
and working principle appear before technical sections, and the separate
specifications table follows them. Matching working-principle text and the
same circuit-symbol image are not redundantly shown twice.

The page displays only stored sections. Missing category-required sections
are returned as diagnostics and logged to the browser console at debug level;
they do not create fake content or blank section placeholders. Existing
specification records satisfy the electrical-specifications diagnostic even
when that section is not duplicated in component_content.

## Images and other assets

The dump contains references to SVG/image resources but no image files.
`database/media-manifest.txt` lists the 78 unique image paths in the supplied
seed dump. Add the real files under `public/images`, preserving their relative
paths. For example:

```text
Database:  /images/flip-flops/jk.svg
Disk:      public/images/flip-flops/jk.svg
```

Missing images show explanatory fallback panels instead of broken-image icons.
The only provided decorative SVG is the ElectroDB favicon; it is not a
technical diagram. No placeholder diagram is represented as verified data.

Same-origin resources are supported over HTTP in development; external
resource URLs must use HTTPS. Executable schemes, remote HTTP resources, and
credential-bearing URLs are rejected. Documents open in a separate tab with
noopener/noreferrer. Document links are not pre-fetched to verify existence,
so maintain their targets yourself.

## Seed-content accuracy

The SQL is preserved, not silently repaired. Some required sections are not
populated, and several numerical specifications are explicitly illustrative.
The app distinguishes unavailable content from real educational resources.

Review the following seed-data inconsistencies before publishing:

- The multiplexer selection tables at content_id 60 and 63 label select bits
  such that S0 behaves as the most significant bit, whereas the component
  text/equation uses the usual S1S0 / S2S1S0 convention.
- Decoder tables at content_id 66 and 69 have the analogous reversed-bit-label
  issue relative to the stored component explanation/equations.

These are source-content issues, not rendering corrections; their values are
returned and shown unchanged. Verify the intended convention and correct the
SQL/database deliberately before using the site as a teaching reference.

## Project structure

```text
electrodb-app/
├── package.json
├── .env.example
├── .gitignore
├── README.md
├── VALIDATION.md
├── database/
│   ├── electrodb.sql
│   ├── create-reader.example.sql
│   └── media-manifest.txt
├── src/
│   ├── config.js
│   ├── db.js
│   ├── utils.js
│   ├── catalogue.js
│   ├── app.js
│   └── server.js
├── public/
│   ├── index.html
│   ├── favicon.svg
│   ├── css/style.css
│   ├── js/api.js
│   ├── js/render.js
│   ├── js/app.js
│   └── images/README.md
├── scripts/
│   ├── check-db.js
│   └── smoke.js
└── test/
    ├── api.test.js
    ├── catalogue.test.js
    ├── render.test.js
    └── utils.test.js
```

## Configuration and deployment notes

- Default HOST=127.0.0.1 is intentionally local-only. Set HOST=0.0.0.0 when
  appropriate for your hosting environment or LAN, and restrict network access.
- Use NODE_ENV=production behind an HTTPS endpoint for deployment. Development
  disables HSTS and CSP upgrade-insecure-requests to support local HTTP.
- DB credentials are used only by Node. `/config.js` exposes only the API path.
- PUBLIC_API_BASE_URL is normally `/api`. The implementation assumes same-origin
  hosting. A separate origin requires deliberate CORS and CSP connect-src
  configuration; simply changing this value is not sufficient.
- The API limit is 120 requests per minute per client using an in-process store.
  Multi-instance deployments need a shared limiter store and trusted proxy
  configuration. Do not broadly trust arbitrary forwarded client-IP headers.
- Keep the read-only database account and firewall the database port. No
  write endpoints, sessions, authentication, or CSRF-sensitive operations exist.
- Current search uses parameterized LIKE scans for simplicity. Benchmark larger
  catalogues before introducing a FULLTEXT migration; none is applied here.
- Production monitoring, backups, managed secrets, and browser/end-to-end
  verification are deployment responsibilities, not included services.

## Troubleshooting

- ECONNREFUSED: start the database and check DB_HOST/DB_PORT.
- ER_ACCESS_DENIED_ERROR: check the account, password, and matching host grant.
- ER_BAD_DB_ERROR: create the database and confirm DB_NAME.
- ER_NO_SUCH_TABLE: import the dump into the database named in `.env`.
- EADDRINUSE: choose another PORT.
- Missing diagrams: add the assets listed in database/media-manifest.txt.
- Unstyled equations: complete npm install and check that
  /vendor/katex/katex.min.css and /vendor/katex/katex.min.js are served.
- A live smoke failure: check server logs and run npm run check before treating
  unit-test success as database integration verification.
