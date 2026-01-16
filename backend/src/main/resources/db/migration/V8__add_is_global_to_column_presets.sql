-- Add is_global flag to column_presets for shared presets
ALTER TABLE column_presets ADD COLUMN is_global BOOLEAN DEFAULT FALSE;

-- Index for fast lookup of global presets
CREATE INDEX idx_column_presets_global ON column_presets(is_global) WHERE is_global = TRUE;
