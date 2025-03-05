from fastapi import FastAPI, WebSocket, WebSocketDisconnect
import cv2
import numpy as np
from jina import Client

app = FastAPI()

jina_client = Client(host='http://127.0.0.1:5000')

@app.websocket("/video")
async def video_chat(websocket: WebSocket):
    await websocket.accept()

    try:
        while True:
            # Gelen video frame'ini al
            frame = await websocket.receive_bytes()

            # Jina'ya gönder
            docs = jina_client.post("/", frame)

            # Jina'dan gelen yanıtı gönder
            response = docs[0].tensor
            await websocket.send_bytes(response)
    except WebSocketDisconnect:
        print("WebSocket bağlantısı kesildi.")
