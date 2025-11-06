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

app.listen(PORT, () => console.log(`Server running on http://127.0.0.1:${PORT}`));
