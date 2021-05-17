const db = require("../config/database");

// ==> Método responsável por criar um novo 'Estado':
exports.createEstado = async (req, res) => {
  const { sigla, nome } = req.body;
  const { rows } = await db.query(
    "INSERT INTO estado(sigla, nome) VALUES ($1, $2)",
    [sigla, nome]
  );
  res.status(201).send({
    message: "Estado added successfully!",
    body: {
      product: { sigla, nome },
    },
  });
};
// ==> Método responsável por listar todos os 'Estado':
exports.listAllEstados = async (req, res) => {
  const response = await db.query("SELECT * FROM estado ORDER BY nome ASC");
  res.status(200).send(response.rows);
};

// ==> Método responsável por selecionar 'Estado' pelo 'sigla':
exports.findEstadoBySigla = async (req, res) => {
  const estadoSigla = req.params.sigla;
  const response = await db.query("SELECT * FROM estado WHERE sigla = $1", [
    estadoSigla,
  ]);
  res.status(200).send(response.rows);
};

// ==> Método responsável por atualizar um 'Estado' pela 'sigla':
exports.updateEstadoBySigla = async (req, res) => {
  const estadoSigla = req.params.sigla;
  const { sigla, nome} = req.body;
  const response = await db.query(
    "UPDATE cidade SET sigla = $1, nome = $2 WHERE sigla = $3",
    [sigla, nome, cidadeSigla]
  );
  res.status(200).send({ message: "Estado Updated Successfully!" });
};

// ==> Método responsável por excluir um 'Estado' pela 'sigla':
exports.deleteEstadoBySigla = async (req, res) => {
  const estadoSigla = req.params.sigla;
  await db.query("DELETE FROM estado WHERE sigla = $1", [estadoSigla]);
  res.status(200).send({ message: "Estado deleted successfully!", estadoSigla });
};
