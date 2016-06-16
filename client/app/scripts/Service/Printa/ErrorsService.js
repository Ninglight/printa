angular.module('printa').service('ErrorsService', ['Restangular', 'PrintaRestangular', function(Restangular, PrintaRestangular) {

    let errors = PrintaRestangular.all('errors');

    return {
        getErrors: function(){
            return errors.getList().$object;
        },
        getError: function(id){
            return PrintaRestangular.one('errors', id).get();
        },
        newError: function(errorData){
            return errors.post(errorData);
        }

    }

}]);
