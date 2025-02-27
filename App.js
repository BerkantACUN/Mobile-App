import React, { useEffect, useState } from 'react';
import axios from 'axios';
import io from 'socket.io-client';

const socket = io('http://localhost:3000');

function App() {
  const [calls, setCalls] = useState([]);

  useEffect(() => {
    // Çağrıları getir
    axios.get('http://localhost/api.php?action=getCalls')
      .then(response => setCalls(response.data));

    // WebSocket ile çağrıları dinle
    socket.on('newCall', (call) => {
      setCalls(prevCalls => [...prevCalls, call]);
    });
  }, []);

  return (
    <div>
      <h1>Çağrı Yönetim Paneli</h1>
      <ul>
        {calls.map((call, index) => (
          <li key={index}>{call.username} - {call.status}</li>
        ))}
      </ul>
    </div>
  );
}

export default App;