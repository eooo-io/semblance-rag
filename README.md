# Semblance RAG/KAG

![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat&logo=docker&logoColor=white)
![Docker Compose](https://img.shields.io/badge/Docker--Compose-1488C6?style=flat&logo=docker&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=flat&logo=python&logoColor=white)
![FastAPI](https://img.shields.io/badge/FastAPI-009688?style=flat&logo=fastapi&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=flat&logo=postgresql&logoColor=white)
![Redis](https://img.shields.io/badge/Redis-DC382D?style=flat&logo=redis&logoColor=white)
![MinIO](https://img.shields.io/badge/MinIO-CF2A27?style=flat&logo=minio&logoColor=white)
![Elasticsearch](https://img.shields.io/badge/Elasticsearch-005571?style=flat&logo=elasticsearch&logoColor=white)
![Weaviate](https://img.shields.io/badge/Weaviate-FF5B5B?style=flat&logo=weaviate&logoColor=white)
![Python venv](https://img.shields.io/badge/venv-%23000000.svg?style=flat&logo=python&logoColor=white)
![Pip](https://img.shields.io/badge/Pip-3776AB?style=flat&logo=pypi&logoColor=white)
![Open Source Love](https://img.shields.io/badge/Open--Source-%E2%9D%A4-red?style=flat)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)

Semblance RAG is a modular Retrieval-Augmented Generation (RAG) platform designed to support knowledge indexing, semantic search, and language model augmentation workflows. It leverages containerized microservices to ensure a flexible and extensible architecture for AI-enabled applications.

---

## Architecture Overview

This project is composed of the following core services, managed via Docker Compose:

### API (FastAPI)
- Provides REST endpoints for query handling and health checks.
- Integrates with Weaviate and language model APIs (e.g. OpenAI).

### WebApp (Laravel PHP Backend)
- Contains business logic, orchestration routines, and potential user interface integration.
- Suitable for administrative interfaces or broader platform integration.

### Weaviate
- Vector search engine used for semantic retrieval.
- Utilizes the `text2vec-openai` module for text embedding.

### Frontend
- Placeholder for a future browser-based UI.
- May include chat interface or RAG analytics dashboard.

### OpenAI Proxy
- Middleware layer for forwarding or managing API access to OpenAI or other model providers.
- Can be used for logging, rate limiting, or environment abstraction.

### Logstash
- Handles log ingestion and routing to Elasticsearch.
- Can also support document preprocessing and indexing.

### Elasticsearch
- Indexing and search backend used for storing structured logs or documents.
- Works in tandem with Logstash and Kibana.

### Kibana
- Web-based dashboard for monitoring and exploring data stored in Elasticsearch.

---

## Setup and Installation

### Prerequisites
- Docker and Docker Compose
- Git
- OpenAI API Key (if using OpenAI-based embeddings or completion)

### Clone Repository

```bash
git clone git@github.com:eooo-io/semblance-rag.git
cd semblance-rag
```

-----

## Access Points

| Service       | URL                         |
|---------------|-----------------------------|
| FastAPI Docs  | http://localhost:8000/docs  |
| Laravel App   | http://localhost:9000       |
| Kibana        | http://localhost:5601       |


---

## Example Query

Send a POST request to `/query`:

```json
{
  "query": "What is Semblance?",
  "top_k": 5
}
```

Expected response includes top-ranked document chunks and associated metadata.

---

## Project Roadmap

Planned features and enhancements include:

- Support for local GPU-backed model inference via Ollama and HuggingFace models.
- Integration of a full ingestion pipeline with semantic chunking.
- Document upload and management via the Laravel backend.
- Role-based access control for secure deployments.
- Scalable deployment strategy (e.g., Docker Swarm or Kubernetes).

---

## Contributing

This project is in active development. Currently NOT looking for contributions.

---

## License

This repository is licensed under the MIT License. See [LICENSE](https://github.com/eooo-io/semblance-rag/blob/main/LICENSE.md) for details.
