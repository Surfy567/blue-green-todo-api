const express = require('express');
const app = express();
const port = 3000;
const VERSION = process.env.VERSION || 'unknown';

app.get('/', (req, res) => {
  res.send(`Hello from the ${VERSION} environment!`);
});

app.get('/health', (req, res) => {
  res.send('OK');
});

app.listen(port, () => {
  console.log(`App listening on port ${port} - Version: ${VERSION}`);
});
