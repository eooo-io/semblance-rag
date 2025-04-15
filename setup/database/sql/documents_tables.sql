-- ============================================
-- ENUM: Document Types
-- ============================================
CREATE TYPE document_type AS ENUM ('book', 'paper', 'article');

-- ============================================
-- BOOKS + CHUNKS
-- ============================================
CREATE TABLE books (
  id SERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  author TEXT,
  description TEXT,
  filename TEXT,
  content TEXT,
  metadata JSONB,
  source_bucket TEXT,
  status TEXT DEFAULT 'raw',
  fts_content TSVECTOR,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_books_status ON books(status);
CREATE INDEX idx_books_title ON books(title);
CREATE INDEX idx_books_fts ON books USING GIN(fts_content);

CREATE TABLE book_chunks (
  id SERIAL PRIMARY KEY,
  book_id INTEGER REFERENCES books(id) ON DELETE CASCADE,
  chunk_index INTEGER,
  content TEXT,
  embedding VECTOR(1536),
  metadata JSONB,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_book_chunks_book_id ON book_chunks(book_id);
CREATE INDEX idx_book_chunks_chunk_index ON book_chunks(chunk_index);

-- ============================================
-- PAPERS + CHUNKS
-- ============================================
CREATE TABLE papers (
  id SERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  authors TEXT,
  publication TEXT,
  year INTEGER,
  doi TEXT UNIQUE,
  filename TEXT,
  abstract TEXT,
  content TEXT,
  metadata JSONB,
  source_bucket TEXT,
  status TEXT DEFAULT 'raw',
  fts_content TSVECTOR,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_papers_doi ON papers(doi);
CREATE INDEX idx_papers_title ON papers(title);
CREATE INDEX idx_papers_fts ON papers USING GIN(fts_content);

CREATE TABLE paper_chunks (
  id SERIAL PRIMARY KEY,
  paper_id INTEGER REFERENCES papers(id) ON DELETE CASCADE,
  chunk_index INTEGER,
  content TEXT,
  embedding VECTOR(1536),
  metadata JSONB,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_paper_chunks_paper_id ON paper_chunks(paper_id);
CREATE INDEX idx_paper_chunks_chunk_index ON paper_chunks(chunk_index);

-- ============================================
-- ARTICLES + CHUNKS
-- ============================================
CREATE TABLE articles (
  id SERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  author TEXT,
  source TEXT,
  url TEXT,
  published_at TIMESTAMP,
  filename TEXT,
  content TEXT,
  metadata JSONB,
  source_bucket TEXT,
  status TEXT DEFAULT 'raw',
  fts_content TSVECTOR,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_articles_url ON articles(url);
CREATE INDEX idx_articles_title ON articles(title);
CREATE INDEX idx_articles_fts ON articles USING GIN(fts_content);

CREATE TABLE article_chunks (
  id SERIAL PRIMARY KEY,
  article_id INTEGER REFERENCES articles(id) ON DELETE CASCADE,
  chunk_index INTEGER,
  content TEXT,
  embedding VECTOR(1536),
  metadata JSONB,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_article_chunks_article_id ON article_chunks(article_id);
CREATE INDEX idx_article_chunks_chunk_index ON article_chunks(chunk_index);

-- ============================================
-- FTS TRIGGER FUNCTION
-- ============================================
CREATE FUNCTION update_fts_content() RETURNS trigger AS $$
BEGIN
  NEW.fts_content := to_tsvector('english', coalesce(NEW.content, ''));
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- TRIGGERS FOR FTS
CREATE TRIGGER trg_books_fts BEFORE INSERT OR UPDATE ON books
FOR EACH ROW EXECUTE FUNCTION update_fts_content();

CREATE TRIGGER trg_papers_fts BEFORE INSERT OR UPDATE ON papers
FOR EACH ROW EXECUTE FUNCTION update_fts_content();

CREATE TRIGGER trg_articles_fts BEFORE INSERT OR UPDATE ON articles
FOR EACH ROW EXECUTE FUNCTION update_fts_content();

-- ============================================
-- UNIFIED DOCUMENT VIEW
-- ============================================
CREATE VIEW documents_view AS
SELECT id, 'book'::document_type AS type, title, content, metadata, created_at FROM books
UNION
SELECT id, 'paper'::document_type AS type, title, content, metadata, created_at FROM papers
UNION
SELECT id, 'article'::document_type AS type, title, content, metadata, created_at FROM articles;
