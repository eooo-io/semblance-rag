CREATE TABLE articles (
  id SERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  author TEXT,
  source TEXT,                -- e.g. website, newspaper
  url TEXT,
  published_at TIMESTAMP,
  filename TEXT,
  content TEXT,
  metadata JSONB,
  source_bucket TEXT,
  status TEXT DEFAULT 'raw',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
