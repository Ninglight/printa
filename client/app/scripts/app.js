require('angular');
require('angular-ui-router');
require('restangular');
require('satellizer');
require('angular-material');
require("angular-uuid");
require("angular-md5");

// dependencie of Restangular
const _ = require('lodash');

// Declaration of dependencies
angular.module('printa', ['ui.router', 'restangular', 'satellizer', 'ngMaterial', 'angular-uuid', 'angular-md5']);

// Import Restangular base configuration
require('./base');

// Import Router
require('./router');

// Import Service from ApiPersona
require('./Service/Persona/UsersService');
require('./Service/Persona/UsersStructuresService');
require('./Service/Persona/StructuresService');

// Import Service from ApiMateria
require('./Service/Materia/ModelsPrintersService');
require('./Service/Materia/ModelsService');
require('./Service/Materia/PrintersService');
require('./Service/Materia/LocationsService');
require('./Service/Materia/TrademarksService');

// Import Service from ApiPrinta
require('./Service/Printa/ActionsService');
require('./Service/Printa/ColorsService');
require('./Service/Printa/CommandsDefaultsService');
require('./Service/Printa/CommandsService');
require('./Service/Printa/CostsService');
require('./Service/Printa/CountersService');
require('./Service/Printa/ErrorsService');
require('./Service/Printa/FormatsService');
require('./Service/Printa/OidsService');
require('./Service/Printa/PagesService');
require('./Service/Printa/PrintingsService');
require('./Service/Printa/SidesService');
require('./Service/Printa/TypesErrorsService');
require('./Service/Printa/TypesService');
require('./Service/Printa/StatusService');
require('./Service/Printa/PrintersStatusService');
require('./Service/Printa/MaintenancesService');
require('./Service/Printa/PrintersMaintenancesService');
require('./Service/Printa/PermissionsService');
require('./Service/Printa/UsersPermissionsService');

// Import Controller
require('./Controller/AuthController');
require('./Controller/UserController');

require('./Controller/IndexController');
require('./Controller/HomeController');
require('./Controller/SearchController');
require('./Controller/InstallController');
require('./Controller/ViewController');
require('./Controller/ManageController');
