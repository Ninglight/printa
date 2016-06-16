angular.module('printa').service('StatusService', ['Restangular', 'MateriaRestangular', function(Restangular, MateriaRestangular) {

    let status = MateriaRestangular.all('status');

    return {
        getStatus: function(){
            return status.getList().$object;
        },
        getStatu: function(id){
            return MateriaRestangular.one('status', id).get();
        },
        newStatu: function(statuData){
            return status.post(statuData);
        }
    }

}]);
