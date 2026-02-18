# Fokosh Bread Tracker Setup

## Supabase Table Setup

Run this SQL in your Supabase Dashboard (SQL Editor):

```sql
-- Create the breads table
CREATE TABLE fokosh_breads (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  active BOOLEAN DEFAULT false,
  baked_today INT DEFAULT 0,
  sold_today INT DEFAULT 0,
  sort_order INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable Row Level Security (but allow all for now - no auth)
ALTER TABLE fokosh_breads ENABLE ROW LEVEL SECURITY;

-- Allow anyone to read/write (for simplicity - no login required)
CREATE POLICY "Allow all" ON fokosh_breads FOR ALL USING (true) WITH CHECK (true);

-- Enable realtime
ALTER PUBLICATION supabase_realtime ADD TABLE fokosh_breads;

-- Insert some starter breads
INSERT INTO fokosh_breads (name, sort_order) VALUES
  ('Sourdough', 1),
  ('Ciabatta', 2),
  ('Focaccia', 3),
  ('Baguette', 4),
  ('Whole Wheat', 5),
  ('Olive Bread', 6),
  ('Rosemary Garlic', 7),
  ('Jalapeño Cheddar', 8);
```

## Daily Reset (Optional)

To reset sold counts each day, you could run:

```sql
UPDATE fokosh_breads SET sold_today = 0, baked_today = 0;
```

Or set up a Supabase Edge Function to run at midnight.

## URLs

- **Tablet (Sales)**: Open the deployed URL
- **Phone (Monitor)**: Same URL - it's responsive

The app syncs in real-time via Supabase subscriptions!
