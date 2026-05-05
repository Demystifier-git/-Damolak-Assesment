from fastapi import FastAPI, Request
from fastapi.responses import Response
from prometheus_client import Counter, Histogram, Gauge, generate_latest, CONTENT_TYPE_LATEST
import time

from app.routes import products, users

app = FastAPI(title="MiniShop API")

# =========================
# í´¹ Prometheus Metrics
# =========================

REQUEST_COUNT = Counter(
    "http_requests_total",
    "Total HTTP Requests",
    ["method", "endpoint", "http_status"]
)

REQUEST_LATENCY = Histogram(
    "http_request_duration_seconds",
    "HTTP request latency",
    ["endpoint"]
)

IN_PROGRESS = Gauge(
    "in_progress_requests",
    "Number of in-progress requests"
)

# =========================
# í´¹ Middleware
# =========================

@app.middleware("http")
async def metrics_middleware(request: Request, call_next):
    IN_PROGRESS.inc()
    start_time = time.time()

    try:
        response = await call_next(request)
    finally:
        IN_PROGRESS.dec()

    latency = time.time() - start_time

    REQUEST_COUNT.labels(
        method=request.method,
        endpoint=request.url.path,
        http_status=response.status_code
    ).inc()

    REQUEST_LATENCY.labels(
        endpoint=request.url.path
    ).observe(latency)

    return response

# =========================
# í´¹ Routes
# =========================

@app.get("/health")
def health_check():
    return {"status": "ok"}

@app.get("/metrics")
def metrics():
    return Response(generate_latest(), media_type=CONTENT_TYPE_LATEST)

app.include_router(products.router, prefix="/products", tags=["Products"])
app.include_router(users.router, prefix="/users", tags=["Users"])
