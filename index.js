const express = require('express');
const app = express();
const port = process.env.PORT || 3000;
app.use(express.json());

let todos = [];

app.get('/health', (req, res) => res.send('OK'));
app.get('/todos', (req, res) => res.json(todos));
app.post('/todos', (req, res) => {
  const todo = { id: Date.now(), text: req.body.text };
  todos.push(todo);
  res.status(201).json(todo);
});

app.listen(port, () => console.log(`Server running on port ${port}`));