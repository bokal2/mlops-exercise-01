import math
from fastapi import FastAPI


app = FastAPI()


def calculate_hypotenus(a: int, b: int) -> float:
    c = math.sqrt(a**2 + b**2)
    return round(c, 2)


@app.get("/")
def healthy():
    return {"status": "Running"}
