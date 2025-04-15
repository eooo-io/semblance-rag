from fastapi import FastAPI, HTTPException, Request
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

# Optional: import your actual RAG pipeline or embedding logic here
# from semblance.rag_pipeline import query_rag_model

app = FastAPI(
    title="Semblance RAG API",
    description="RAG Backend for Semblance-AI",
    version="0.1.0",
)

# CORS config (customize for prod)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Set to specific domain in prod
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Request schema for querying the system
class QueryRequest(BaseModel):
    query: str
    top_k: int = 5


# Simple health check endpoint
@app.get("/")
async def root():
    return {"message": "Semblance RAG API is live 🚀"}


# Endpoint for RAG queries
@app.post("/query")
async def query_rag(request: QueryRequest):
    try:
        # Placeholder for your actual RAG logic
        # results = query_rag_model(request.query, top_k=request.top_k)
        results = {
            "query": request.query,
            "top_k": request.top_k,
            "results": [
                {"doc_id": "001", "score": 0.91, "text": "Example retrieved chunk #1"},
                {"doc_id": "002", "score": 0.87, "text": "Example retrieved chunk #2"},
            ],
        }
        return results

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
