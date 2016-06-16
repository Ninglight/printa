angular.module('printa').service('TypeErrorsService', ['Restangular', 'PrintaRestangular', function(Restangular, PrintaRestangular) {

    let typesErrors = PrintaRestangular.all('types_errors');

    return {
        getTypesErrors: function(){
            return typesErrors.getList().$object;
        },
        getTypeError: function(id){
            return PrintaRestangular.one('types_errors', id).get();
        },
        newTypeError: function(typeErrorData){
            return typesErrors.post(typeErrorData);
        }

    }

}]);
