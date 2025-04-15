CREATE TABLE papers (
  id SERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  authors TEXT,
  publication TEXT,           -- e.g. Nature, arXiv, etc.
  year INTEGER,
  doi TEXT UNIQUE,
  filename TEXT,
  abstract TEXT,
  content TEXT,               -- full converted text
  metadata JSONB,
  source_bucket TEXT,
  status TEXT DEFAULT 'raw',  -- raw / cleaned / indexed / vectorized
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
