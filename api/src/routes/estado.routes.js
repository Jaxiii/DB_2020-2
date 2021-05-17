const router = require("express-promise-router")();
const estadoController = require("../controllers/estado.controller");
// ==> Definindo as rotas do CRUD - 'estado':

// ==> Rota responsável por criar uma nova 'estado': (POST): localhost:3000/api/estados
router.post("/estados", estadoController.createEstado);


// ==> Rota responsável por listar todas as 'estados': (GET): localhost:3000/api/estados
router.get("/estados", estadoController.listAllEstados);

// ==> Rota responsável por selecionar 'estado' pela 'sigla': (GET): localhost:3000/api/estados/:sigla
router.get("/estados/:sigla", estadoController.findEstadoBySigla);

// ==> Rota responsável por atualizar 'estado' pela 'sigla': (PUT): localhost: 3000/api/estados/:sigla
router.put("/estados/:sigla", estadoController.updateEstadoBySigla);

// ==> Rota responsável por excluir 'estado' pela 'sigla': (DELETE): localhost:3000/api/estados/:sigla
router.delete("/estados/:sigla", estadoController.deleteEstadoBySigla);

module.exports = router;