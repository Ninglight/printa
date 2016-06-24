angular.module('printa').service('StatusService', ['Restangular', 'PrintaRestangular', function(Restangular, PrintaRestangular) {

    let status = PrintaRestangular.all('status');

    return {
        getStatus: function(){
            return status.getList().$object;
        },
        getStatu: function(id){
            return PrintaRestangular.one('status', id).get();
        },
        newStatu: function(statuData){
            return status.post(statuData);
        }
    }

}]);
