#  Damolak Assesment

#  MiniShop – Production-Ready DevOps Deployment

##  Overview

MiniShop is a containerized full-stack application designed to demonstrate real-world DevOps practices, including:

- Docker-based microservice-style architecture
- CI/CD-ready structure
- Observability (metrics, logs, tracing)
- Monitoring with Prometheus and Grafana (otel-collector added to export metrics to prometheus)
- Centralized logging with Loki + Promtail
- Backend instrumentation using FastAPI middleware
- Amazon documentdb for data persistence
- ACM to get ssl certificate for https configuration


---

#  Architecture

Internet
   ↓
Load Balancer (VM)
   ↓
------------------------------------------------
VM (Docker Host)
 ├── Frontend (Nginx - :80)
 ├── Backend (FastAPI - :8000)
 ├── MongoDB
 ├── Prometheus (:9090)
 ├── Grafana (:3001)
 ├── Loki (:3100)
 ├── Promtail
 └── OpenTelemetry Collector (:4317/:4318)
------------------------------------------------

---

#  Services

##  Frontend
Static website served via Nginx.

URL:
https://delightdavid.online

---

##  Backend (FastAPI)

REST API with observability instrumentation.

### Endpoints

Health Check:
GET /health

Metrics (Prometheus):
GET /metrics

Products:
GET    /products
POST   /products
PUT    /products/{id}
DELETE /products/{id}

Users:
POST /users/register
POST /users/login
GET  /users/me

Base URL:
https://delightdavid.online

---

##  Database (MongoDB)

- Stores application data
- Initialized using Docker init scripts
- Persistent volume storage enabled

---

##  Prometheus

- Scrapes backend metrics
- Collects HTTP request stats, latency, and system metrics

URL:
http://prometheus.delightdavid.online

---

##  Grafana

- Visualizes metrics from Prometheus
- Displays logs from Loki

URL:
https://grafana.delightdavid.online

---

##  Loki

- Centralized log storage system
- Receives logs via Promtail
- Queried inside Grafana using LogQL

---

##  Promtail

- Collects logs from Docker containers
- Sends logs to Loki for storage and querying

---

##  OpenTelemetry Collector

- Receives telemetry data (metrics/traces)
- Exposes metrics for Prometheus
- Supports gRPC and HTTP ingestion

---

#  Observability Flow

## Metrics Flow
Backend → /metrics → Prometheus → Grafana

## Logs Flow
Containers → Promtail → Loki → Grafana

---

#  Run the Project

## 1. Clone repository
git clone <repo-url>
cd project

## 2. Setup environment
cp .env.example .env

## 3. Start services
docker compose up --build

---

#  Access URLs

Application:     https://delightdavid.online
Prometheus:   https://prometheus.delightdavid.online 
Grafana:      http://grafana.delightdavid.online 

---

#  Metrics Collected

The backend exposes the following Prometheus metrics:

- http_requests_total
- http_request_duration_seconds
- in_progress_requests

#  CI/CD


- Build
- test
- deploy

---

#  Logging

Logs are collected using:

- Docker container logs
- Promtail log shipper
- Loki storage backend
- Grafana visualization

Example LogQL query:

{job="docker-containers"}

---

#  Security Notes

- Amazondocumentdb was used as the database with env variables stored in secret manager
- Internal Docker networking used for service communication
- No direct public exposure of Loki or internal services
- Observability stack accessed via Grafana only

---



#  DevOps Concepts Demonstrated

- Docker containerization
- Multi-service orchestration
- Observability (metrics, logs)
- Prometheus monitoring
- Grafana visualization
- Centralized logging (Loki + Promtail)
- FastAPI middleware instrumentation
- Production-style architecture design
- Autoscaling implemented
- Infrastructure provisioned with terrafrom with remotestate backend configured
- https configured for application as well as prometheus and grafana
- Loadbalancer configured to route application traffic
- 

---

#  Summary

This project simulates a production-grade DevOps environment with:

- Scalable architecture
- Full observability stack
- Modular service design
- Cloud-native monitoring practices

---

#  Author

Chukwuagoziem delight david, DevOps Engineer Practical Challenge Submission.


