from fastapi import FastAPI
from jina import Client

app = FastAPI()
jina_client = Client(host="grpc://your_jina_server_url")

@app.get("/search")
async def search(query: str):
    response = jina_client.post("/", inputs=[query])
    return {"result": response}
