from fastapi import FastAPI
from app.core.database import engine
from app.models import models
from app.api.endpoints import operadoras, estatisticas

models.Base.metadata.create_all(bind=engine)

app = FastAPI(title="API Operadoras ANS")
app.include_router(operadoras.router, prefix="/api/operadoras", tags=["operadoras"])
app.include_router(estatisticas.router, prefix="/api/estatisticas", tags=["estatisticas"])

@app.get("/")
def health_check():
    return {"status": "online"}