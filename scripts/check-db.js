import { pool } from '../src/db.js';
const tables = ['categories','category_content_types','components','component_content',
  'component_specifications','component_tag','content_types','specifications','tags'];
try {
  for (const table of tables) {
    const [[{ total }]] = await pool.execute(`SELECT COUNT(*) AS total FROM \`${table}\``);
    console.log(`${table}: ${total}`);
  }
  const [bad] = await pool.execute(`SELECT cc.content_id,cc.component_id FROM component_content cc
    JOIN content_types ct ON ct.content_type_id=cc.content_type_id
    WHERE ct.data_format='TABLE' AND NOT JSON_VALID(cc.content)`);
  console.log(`Invalid JSON tables: ${bad.length}`);
  const [missing] = await pool.execute(`SELECT p.component_id,p.name,ct.name AS missing_section
    FROM components p JOIN category_content_types cct ON cct.category_id=p.category_id
    JOIN content_types ct ON ct.content_type_id=cct.content_type_id
    WHERE cct.is_required=1 AND NOT EXISTS (
      SELECT 1 FROM component_content cc WHERE cc.component_id=p.component_id AND cc.content_type_id=cct.content_type_id)
    AND NOT (ct.name='Electrical Specifications' AND EXISTS (
      SELECT 1 FROM component_specifications cs WHERE cs.component_id=p.component_id))
    AND NOT (ct.name='Circuit Symbol' AND p.circuit_symbol_url IS NOT NULL AND p.circuit_symbol_url<>'')
    AND NOT (ct.name='Working Principle' AND p.working_principle IS NOT NULL AND p.working_principle<>'')`);
  console.log(`Missing configured required sections: ${missing.length} (non-fatal educational seed gaps)`);
  console.table(missing.slice(0,20));
} catch (error) {
  console.error('Database check failed:', error.code || error.message); process.exitCode = 1;
} finally { await pool.end(); }
