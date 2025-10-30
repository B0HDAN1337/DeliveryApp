import express from 'express';
import cors from 'cors';
import bodyParser from 'body-parser';
import fetch from 'node-fetch'; // ✅ для Node < 18

const app = express();
const PORT = 3000;

app.use(cors());
app.use(bodyParser.json());

const points = [
  { name: 'UBB', lat: 49.78559, lon: 19.057272 },
  { name: 'Hotel Prezydent', lat: 49.823603, lon: 19.044912 },
  { name: 'Akademik', lat: 49.81694, lon: 19.01467 },
];

app.get('/points', (req, res) => res.json(points));

app.post('/route', async (req, res) => {
  try {
    const { waypoints } = req.body;
    if (!waypoints || waypoints.length < 2) {
      return res.status(400).json({ error: 'Invalid waypoints' });
    }

    const coords = waypoints.map(w => `${w.lon},${w.lat}`).join(';');
    const url = `https://router.project-osrm.org/route/v1/driving/${coords}?overview=full&geometries=geojson`;

    console.log('Fetching:', url);
    const osrmRes = await fetch(url);
    const data = await osrmRes.json();

    if (!data.routes || data.routes.length === 0) {
      return res.status(500).json({ error: 'No route found' });
    }

    res.json(data.routes[0]);
  } catch (err) {
    console.error('Error in /route:', err);
    res.status(500).json({ error: err.message });
  }
});

app.listen(PORT, () => console.log(`Server running on http://127.0.0.1:${PORT}`));
