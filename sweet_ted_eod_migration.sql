-- ============================================================================
-- Sweet Ted Cafe — Optional EOD Inventory Counts table
-- Run this once in the Supabase SQL Editor.
-- This script DOES NOT alter any of your existing tables (ingredients,
-- batches, sales). It only ADDS a new optional table for persisting
-- end-of-day inventory counts if you ever want to save them in the future.
--
-- The current Final_v6.html does NOT require this table — the End of Day
-- report works fully with PDF download alone. Run this only if you want to
-- start storing the counts in the database later.
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.eod_inventory_counts (
  id            BIGSERIAL PRIMARY KEY,
  count_date    DATE        NOT NULL DEFAULT CURRENT_DATE,
  barista_name  TEXT        NOT NULL,
  ingredient_id BIGINT      REFERENCES public.ingredients(id) ON DELETE CASCADE,
  ingredient_name TEXT,
  start_count   NUMERIC     DEFAULT 0,
  end_count     NUMERIC     DEFAULT 0,
  items_used    NUMERIC GENERATED ALWAYS AS (start_count - end_count) STORED,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS eod_inventory_counts_date_idx
  ON public.eod_inventory_counts (count_date);

-- Enable RLS (matches the same permissive pattern used by your other tables
-- since the front-end uses the publishable anon key).
ALTER TABLE public.eod_inventory_counts ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "eod_select_all" ON public.eod_inventory_counts;
CREATE POLICY "eod_select_all"
  ON public.eod_inventory_counts FOR SELECT
  USING (true);

DROP POLICY IF EXISTS "eod_insert_all" ON public.eod_inventory_counts;
CREATE POLICY "eod_insert_all"
  ON public.eod_inventory_counts FOR INSERT
  WITH CHECK (true);

DROP POLICY IF EXISTS "eod_update_all" ON public.eod_inventory_counts;
CREATE POLICY "eod_update_all"
  ON public.eod_inventory_counts FOR UPDATE
  USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "eod_delete_all" ON public.eod_inventory_counts;
CREATE POLICY "eod_delete_all"
  ON public.eod_inventory_counts FOR DELETE
  USING (true);

-- Done.
