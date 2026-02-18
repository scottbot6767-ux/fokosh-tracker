-- Fkosh Database Setup
-- Run this in Supabase SQL Editor: https://supabase.com/dashboard/project/ryxrgbvymudmqqpefmmf/sql

-- 1. Bread flavors table
CREATE TABLE IF NOT EXISTS fkosh_breads (
  id BIGSERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  active BOOLEAN DEFAULT false,
  baked_today INTEGER DEFAULT 0,
  sold_today INTEGER DEFAULT 0,
  sort_order INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Daily history table
CREATE TABLE IF NOT EXISTS fkosh_history (
  id BIGSERIAL PRIMARY KEY,
  date TEXT NOT NULL,
  total_sold INTEGER DEFAULT 0,
  items JSONB DEFAULT '[]',
  timestamp TIMESTAMPTZ DEFAULT NOW()
);

-- 3. All-time totals table
CREATE TABLE IF NOT EXISTS fkosh_totals (
  name TEXT PRIMARY KEY,
  total_sold INTEGER DEFAULT 0
);

-- 4. Enable Row Level Security (but allow all for now)
ALTER TABLE fkosh_breads ENABLE ROW LEVEL SECURITY;
ALTER TABLE fkosh_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE fkosh_totals ENABLE ROW LEVEL SECURITY;

-- 5. Policies to allow anon access (adjust later if you want auth)
CREATE POLICY "Allow all access to fkosh_breads" ON fkosh_breads FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all access to fkosh_history" ON fkosh_history FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all access to fkosh_totals" ON fkosh_totals FOR ALL USING (true) WITH CHECK (true);

-- 6. Enable realtime for all tables
ALTER PUBLICATION supabase_realtime ADD TABLE fkosh_breads;
ALTER PUBLICATION supabase_realtime ADD TABLE fkosh_history;
ALTER PUBLICATION supabase_realtime ADD TABLE fkosh_totals;

-- 7. Seed with some default flavors (optional - delete if you want to start blank)
INSERT INTO fkosh_breads (name, active, sort_order) VALUES
  ('Classic Rosemary', false, 1),
  ('Jalapeño Cheddar', false, 2),
  ('Garlic Herb', false, 3),
  ('Everything', false, 4),
  ('Sun-dried Tomato', false, 5)
ON CONFLICT DO NOTHING;
