-- ================================
-- LYRICS TABLE (Vector + FTS Ready)
-- ================================

CREATE TABLE lyrics (
  id SERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  artist TEXT,
  lyrics TEXT,
  lyrics_embedding VECTOR(1536),         -- 🧠 Vector for semantic lyric search
  fts_lyrics TSVECTOR,                   -- 🔍 FTS vector for raw text
  source TEXT,
  metadata JSONB,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ================================
-- INDEXES
-- ================================

-- Full-text search index
CREATE INDEX idx_lyrics_fts ON lyrics USING GIN (fts_lyrics);

-- Optional: Cosine similarity index (requires pgvector with IVFFlat)
-- CREATE INDEX idx_lyrics_embedding_cosine
-- ON lyrics USING ivfflat (lyrics_embedding vector_cosine_ops)
-- WITH (lists = 100);

-- ================================
-- FTS TRIGGER FUNCTION
-- ================================

CREATE FUNCTION update_lyrics_fts() RETURNS trigger AS $$
BEGIN
  NEW.fts_lyrics := to_tsvector('english', coalesce(NEW.lyrics, ''));
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ================================
-- FTS TRIGGER
-- ================================

CREATE TRIGGER trg_lyrics_fts
BEFORE INSERT OR UPDATE ON lyrics
FOR EACH ROW EXECUTE FUNCTION update_lyrics_fts();


-- ===================================
-- LYRICS CHUNKS TABLE
-- ===================================

CREATE TABLE lyrics_chunks (
  id SERIAL PRIMARY KEY,
  lyrics_id INTEGER REFERENCES lyrics(id) ON DELETE CASCADE,
  chunk_index INTEGER,
  content TEXT,
  embedding VECTOR(1536),
  fts_chunk TSVECTOR,
  metadata JSONB,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX idx_lyrics_chunks_lyrics_id ON lyrics_chunks(lyrics_id);
CREATE INDEX idx_lyrics_chunks_chunk_index ON lyrics_chunks(chunk_index);
CREATE INDEX idx_lyrics_chunks_fts ON lyrics_chunks USING GIN(fts_chunk);

-- FTS trigger
CREATE FUNCTION update_lyrics_chunk_fts() RETURNS trigger AS $$
BEGIN
  NEW.fts_chunk := to_tsvector('english', coalesce(NEW.content, ''));
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_lyrics_chunk_fts
BEFORE INSERT OR UPDATE ON lyrics_chunks
FOR EACH ROW EXECUTE FUNCTION update_lyrics_chunk_fts();
