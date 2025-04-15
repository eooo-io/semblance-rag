CREATE TABLE documents (
  id SERIAL PRIMARY KEY,
  filename TEXT NOT NULL,
  title TEXT,
  author TEXT,
  source_type TEXT,        -- e.g. 'pdf', 'epub', 'html'
  source_bucket TEXT,      -- MinIO bucket
  content TEXT,            -- cleaned, normalized text
  metadata JSONB,          -- optional extracted metadata
  status TEXT DEFAULT 'raw',  -- pipeline stage: raw/cleaned/indexed/vectorized
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
