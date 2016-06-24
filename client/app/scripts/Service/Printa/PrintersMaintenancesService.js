angular.module('printa').service('PrintersmaintenancesService', ['Restangular', 'PrintaRestangular', function(Restangular, PrintaRestangular) {

    let printersmaintenances = PrintaRestangular.all('printers_maintenances');

    return {
        getprintersmaintenances: function(){
            return printersmaintenances.getList().$object;
        },
        getprintermaintenance: function(id){
            return PrintaRestangular.one('printers_maintenances', id).get();
        },
        newprintermaintenance: function(printermaintenanceData){
            return printersmaintenances.post(printermaintenanceData);
        }
    }

}]);
