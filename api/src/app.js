const express = require('express');
const cors = require('cors');
const app = express();

// ==> Rotas da API:
const index = require('./routes/index');
const cidadaoRoute = require('./routes/cidadao.routes');
const cidadeRoute = require('./routes/cidade.routes');
const estadoRoute = require('./routes/estado.routes');

app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use(express.json({ type: 'application/vnd.api+json' }));
app.use(cors());
app.use(index);
app.use('/api/', cidadaoRoute);
app.use('/api/', cidadeRoute);
app.use('/api/', estadoRoute);
module.exports = app;
