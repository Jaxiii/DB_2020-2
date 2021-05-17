const router = require("express-promise-router")();
const cidadeController = require("../controllers/cidade.controller");
// ==> Definindo as rotas do CRUD - 'Cidade':

// ==> Rota responsável por criar uma nova 'Cidade': (POST): localhost:3000/api/cidades
router.post("/cidades", cidadeController.createCidade);


// ==> Rota responsável por listar todas as 'Cidades': (GET): localhost:3000/api/cidades
router.get("/cidades", cidadeController.listAllCidades);

// ==> Rota responsável por selecionar 'Cidade' pela 'sigla': (GET): localhost:3000/api/cidades/:sigla
router.get("/cidades/:sigla", cidadeController.findCidadeBySigla);

// ==> Rota responsável por atualizar 'cidade' pela 'sigla': (PUT): localhost: 3000/api/cidades/:sigla
router.put("/cidades/:sigla", cidadeController.updateCidadeBySigla);

// ==> Rota responsável por excluir 'cidade' pela 'sigla': (DELETE): localhost:3000/api/cidades/:sigla
router.delete("/cidades/:sigla", cidadeController.deleteCidadeBySigla);

module.exports = router;
