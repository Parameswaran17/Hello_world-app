const express = require('express');
const app = express();

app.get('', (req, res) => {

  res.send('Hello world'); 
});

const PORT = 3000;
app.listen(3000, () => {
  console.log('Listening on port 3000');
});