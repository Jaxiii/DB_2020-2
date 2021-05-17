const db = require("../config/database");

// ==> Método responsável por criar um novo 'Cidadao':
exports.createCidade = async (req, res) => {
  const { sigla, estado_fk, nome } = req.body;
  const { rows } = await db.query(
    "INSERT INTO cidade(sigla, estado_fk, nome) VALUES ($1, $2, $3)",
    [sigla, estado_fk, nome]
  );
  res.status(201).send({
    message: "Cidade added successfully!",
    body: {
      product: { sigla, estado_fk, nome },
    },
  });
};
// ==> Método responsável por listar todas as 'Cidades':
exports.listAllCidades = async (req, res) => {
  const response = await db.query("SELECT * FROM cidade ORDER BY nome ASC");
  res.status(200).send(response.rows);
};

// ==> Método responsável por selecionar 'Cidade' pelo 'sigla':
exports.findCidadeBySigla = async (req, res) => {
  const cidadeSigla = req.params.sigla;
  const response = await db.query("SELECT * FROM cidade WHERE sigla = $1", [
    cidadeSigla,
  ]);
  res.status(200).send(response.rows);
};

// ==> Método responsável por atualizar uma 'Cidade' pela 'sigla':
exports.updateCidadeBySigla = async (req, res) => {
  const cidadeSigla = req.params.sigla;
  const { sigla, estado_fk, nome} = req.body;
  const response = await db.query(
    "UPDATE cidade SET sigla = $1, estado_fk = $2, nome = $3 WHERE sigla = $4",
    [sigla, estado_fk, nome, cidadeSigla]
  );
  res.status(200).send({ message: "Cidade Updated Successfully!" });
};

// ==> Método responsável por excluir uma 'Cidade' pela 'sigla':
exports.deleteCidadeBySigla = async (req, res) => {
  const cidadeSigla = req.params.sigla;
  await db.query("DELETE FROM cidade WHERE sigla = $1", [cidadeSigla]);
  res.status(200).send({ message: "Cidade deleted successfully!", cidadeSigla });
};
