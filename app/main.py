# app/main.py
from fastapi import FastAPI

app = FastAPI(
    title="fastapi-template",
    version="0.1.0",
)


@app.get("/health", tags=["health"])
def health() -> dict[str, str]:
    return {"status": "ok"}


if __name__ == "__main__":
    print("This is the main module of the FastAPI application.")
