angular.module('printa').service('LocationsService', ['Restangular', 'MateriaRestangular', function(Restangular, MateriaRestangular) {

    let locations = MateriaRestangular.all('locations');

    return {
        getLocations: function(){
            return locations.getList().$object;
        },
        getLocation: function(id){
            return MateriaRestangular.one('locations', id).get();
        },
        newLocation: function(statuData){
            return locations.post(statuData);
        }
    }

}]);
