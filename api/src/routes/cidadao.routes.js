const router = require("express-promise-router")();
const cidadaoController = require("../controllers/cidadao.controller");
// ==> Definindo as rotas do CRUD - 'Cidadao':

// ==> Rota responsável por criar um novo 'Cidadao': (POST): localhost:3000/api/cidadaos
router.post("/cidadaos", cidadaoController.createCidadao);

// ==> Rota responsável por listar todos os 'Cidadaos': (GET): localhost:3000/api/cidadaos
router.get("/cidadaos", cidadaoController.listAllCidadaos);

// ==> Rota responsável por selecionar 'Cidadao' pelo 'cpf': (GET): localhost:3000/api/cidadaos/:cpf
router.get("/cidadaos/:cpf", cidadaoController.findCidadaoByCpf);

// ==> Rota responsável por selecionar 'Cidadao' pelo 'cpf': (GET): localhost:3000/api/cidadaos/:cpf
router.get("/cidadeCidadao/:cidade", cidadaoController.findCidadaosByCidade);

// ==> Rota responsável por atualizar 'Cidadao' pelo 'cpf': (PUT): localhost: 3000/api/cidadaos/:cpf
router.put("/cidadaos/:cpf", cidadaoController.updateCidadaoByCpf);

// ==> Rota responsável por excluir 'Cidadao' pelo 'cpf': (DELETE): localhost:3000/api/cidadaos/:cpf
router.delete("/cidadaos/:cpf", cidadaoController.deleteCidadaoByCpf);

module.exports = router;
