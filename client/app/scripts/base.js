// Global configuration
angular.module('printa').config(function(RestangularProvider) {
   RestangularProvider.setBaseUrl('http://localhost:8000/');
});

//Persona Restangular Service
angular.module('printa').factory('PersonaRestangular', [ 'Restangular', function(Restangular) {
   return Restangular.withConfig(function(RestangularConfigurer) {
      RestangularConfigurer.setBaseUrl('http://localhost:8000/');
   });
}]);

//Materia Restangular Service
angular.module('printa').factory('MateriaRestangular', [ 'Restangular', function(Restangular) {
   return Restangular.withConfig(function(RestangularConfigurer) {
      RestangularConfigurer.setBaseUrl('http://localhost:8001/');
   });
}]);

//Printa Restangular Service
angular.module('printa').factory('PrintaRestangular', [ 'Restangular', function(Restangular) {
   return Restangular.withConfig(function(RestangularConfigurer) {
      RestangularConfigurer.setBaseUrl('http://localhost:8002/');
   });
}]);
