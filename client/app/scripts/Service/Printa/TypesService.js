angular.module('printa').service('TypesService', ['Restangular', 'PrintaRestangular', function(Restangular, PrintaRestangular) {

    let types = PrintaRestangular.all('types');

    return {
        getTypes: function(){
            return types.getList().$object;
        },
        getType: function(id){
            return PrintaRestangular.one('types', id).get();
        },
        newType: function(typeData){
            return types.post(typeData);
        }

    }

}]);
