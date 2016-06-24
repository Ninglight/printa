angular.module('printa').service('MaintenancesService', ['Restangular', 'PrintaRestangular', function(Restangular, PrintaRestangular) {

    let maintenances = PrintaRestangular.all('maintenances');

    return {
        getMaintenances: function(){
            return maintenances.getList().$object;
        },
        getMaintenance: function(id){
            return PrintaRestangular.one('maintenances', id).get();
        },
        newMaintenance: function(maintenanceData){
            return maintenances.post(maintenanceData);
        }
    }

}]);
