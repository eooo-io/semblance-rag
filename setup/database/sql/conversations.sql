-- ================================
-- USERS TABLE (optional)
-- ================================
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) UNIQUE,
    metadata JSONB,
    created_at TIMESTAMP DEFAULT NOW()
);

-- ================================
-- SESSIONS TABLE
-- ================================
CREATE TABLE sessions (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) DEFAULT NULL,
    session_start TIMESTAMP DEFAULT NOW(),
    session_end TIMESTAMP DEFAULT NULL,
    metadata JSONB,
    created_at TIMESTAMP DEFAULT NOW()
);

-- ================================
-- CONVERSATION TURNS TABLE
-- ================================
CREATE TABLE conversation_turns (
    id SERIAL PRIMARY KEY,
    session_id INTEGER REFERENCES sessions(id),
    user_input TEXT NOT NULL,
    agent_response TEXT NOT NULL,
    turn_order INTEGER,
    input_timestamp TIMESTAMP DEFAULT NOW(),
    response_timestamp TIMESTAMP DEFAULT NOW(),
    user_embedding VECTOR(1536),            -- 🧠 Vector for user_input
    response_embedding VECTOR(1536),        -- 🤖 Vector for agent_response
    user_fts TSVECTOR,                      -- 🔍 FTS field
    response_fts TSVECTOR,
    metadata JSONB,
    created_at TIMESTAMP DEFAULT NOW()
);

-- ================================
-- INDEXES
-- ================================
CREATE INDEX idx_session_id ON conversation_turns (session_id);
CREATE INDEX idx_turn_order ON conversation_turns (turn_order);
CREATE INDEX idx_input_timestamp ON conversation_turns (input_timestamp);
CREATE INDEX idx_user_fts ON conversation_turns USING GIN (user_fts);
CREATE INDEX idx_response_fts ON conversation_turns USING GIN (response_fts);

-- ================================
-- FTS TRIGGER FUNCTION
-- ================================
CREATE FUNCTION update_conversation_fts() RETURNS trigger AS $$
BEGIN
  NEW.user_fts := to_tsvector('english', coalesce(NEW.user_input, ''));
  NEW.response_fts := to_tsvector('english', coalesce(NEW.agent_response, ''));
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_conversation_turns_fts
BEFORE INSERT OR UPDATE ON conversation_turns
FOR EACH ROW EXECUTE FUNCTION update_conversation_fts();

-- ===================================
-- CONVERSATION CHUNKS TABLE
-- ===================================

CREATE TABLE conversation_chunks (
  id SERIAL PRIMARY KEY,
  conversation_turn_id INTEGER REFERENCES conversation_turns(id) ON DELETE CASCADE,
  chunk_index INTEGER,
  content TEXT,
  embedding VECTOR(1536),
  fts_chunk TSVECTOR,
  metadata JSONB,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX idx_conversation_chunks_turn_id ON conversation_chunks(conversation_turn_id);
CREATE INDEX idx_conversation_chunks_chunk_index ON conversation_chunks(chunk_index);
CREATE INDEX idx_conversation_chunks_fts ON conversation_chunks USING GIN(fts_chunk);

-- FTS trigger
CREATE FUNCTION update_conversation_chunk_fts() RETURNS trigger AS $$
BEGIN
  NEW.fts_chunk := to_tsvector('english', coalesce(NEW.content, ''));
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_conversation_chunk_fts
BEFORE INSERT OR UPDATE ON conversation_chunks
FOR EACH ROW EXECUTE FUNCTION update_conversation_chunk_fts();
