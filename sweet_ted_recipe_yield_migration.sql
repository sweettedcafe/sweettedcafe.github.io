-- Sweet Ted: add Recipe Yield (reference) to batches
-- Run once on your Supabase project.

ALTER TABLE public.batches
  ADD COLUMN IF NOT EXISTS recipe_yield numeric;

-- Backfill: legacy rows have no recipe_yield, so treat the batch yield as
-- the recipe yield (this keeps existing ingredient amounts unchanged).
UPDATE public.batches
SET recipe_yield = yield_pcs
WHERE recipe_yield IS NULL;

-- Note on ingredients_used JSONB:
-- Old shape: [{ id, name, qty }]
-- New shape: [{ id, name, qty, recipe_qty }]
-- Legacy rows are read with recipe_qty falling back to qty in the app, so
-- no JSON migration is required. They will be migrated automatically the
-- next time the batch is opened and saved.
