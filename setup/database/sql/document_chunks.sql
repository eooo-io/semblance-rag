CREATE TABLE document_chunks (
  id SERIAL PRIMARY KEY,
  parent_type TEXT,               -- 'book', 'paper', 'article', etc.
  parent_id INTEGER,              -- ID from the parent table
  chunk_index INTEGER,
  content TEXT,
  metadata JSONB,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
