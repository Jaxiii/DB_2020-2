const db = require("../config/database");

// ==> Método responsável por criar um novo 'Cidadao':
exports.createCidadao = async (req, res) => {
  const { cpf, nome, data_nascimento } = req.body;
  const { rows } = await db.query(
    "INSERT INTO cidadao (cpf, nome, data_nascimento) VALUES ($1, $2, $3)",
    [cpf, nome, data_nascimento]
  );
  res.status(201).send({
    message: "Cidadao added successfully!",
    body: {
      product: { cpf, nome, data_nascimento},
    },
  });
};

// ==> Método responsável por listar todos os 'Cidadaos':
exports.listAllCidadaos = async (req, res) => {
  const response = await db.query("SELECT * FROM cidadao ORDER BY cpf ASC ");
  res.status(200).send(response.rows);
};

// ==> Método responsável por selecionar 'Cidadao' pelo 'cpf':
exports.findCidadaoByCpf = async (req, res) => {
  const cidadaoCpf = parseInt(req.params.cpf);
  const response = await db.query("SELECT * FROM cidadao WHERE cpf = $1", [
    cidadaoCpf,
  ]);
  res.status(200).send(response.rows);
};

// ==> Método responsável por selecionar 'Cidadao' pelo 'cpf':
exports.findCidadaosByCidade = async (req, res) => {
    const cidade = req.params.cidade;
    const response = await db.query("SELECT * FROM cidadao INNER JOIN endereco C ON C.cidade_fk = $1", [
      cidade,
    ]);
    res.status(200).send(response.rows);
  };

// ==> Método responsável por atualizar um 'Cidadao' pelo 'cpf':
exports.updateCidadaoByCpf = async (req, res) => {
  const cidadaoCpf = parseInt(req.params.cpf);
  const { cpf, nome, data_nascimento } = req.body;
  const response = await db.query(
    "UPDATE cidadao SET cpf = $1, nome = $2, data_nascimento = $3 WHERE cpf = $4",
    [cpf, nome, data_nascimento, cidadaoCpf]
  );
  res.status(200).send({ message: "Cidadao Updated Successfully!" });
};

// ==> Método responsável por excluir um 'Cidadao' pelo 'cpf':
exports.deleteCidadaoByCpf = async (req, res) => {
  const cidadaoCpf = parseInt(req.params.cpf);
  await db.query("DELETE FROM cidadao WHERE cpf = $1", [cidadaoCpf]);
  res.status(200).send({ message: "Cidadao deleted successfully!", cidadaoCpf });
};
