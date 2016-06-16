angular.module('printa').service('StructuresService', ['Restangular', 'PersonaRestangular', function(Restangular, PersonaRestangular) {

    let structures = PersonaRestangular.all('structures');

    return {
        getStructures: function(){
            return structures.getList().$object;
        },
        getStructure: function(id){
            return PersonaRestangular.one('structures', id).get();
        }
    }

}]);
