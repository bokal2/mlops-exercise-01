from fastapi import status
from fastapi.testclient import TestClient

from src.main import app

client = TestClient(app)


def test_healthy_endpoint():
    response = client.get("/health")
    assert response.status_code == status.HTTP_200_OK
