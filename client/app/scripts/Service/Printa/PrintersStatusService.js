angular.module('printa').service('PrintersStatusService', ['Restangular', 'PrintaRestangular', function(Restangular, PrintaRestangular) {

    let printersstatus = PrintaRestangular.all('printers_status');

    return {
        getPrintersStatus: function(){
            return printersstatus.getList().$object;
        },
        getPrinterStatu: function(id){
            return PrintaRestangular.one('printers_status', id).get();
        },
        newPrinterStatu: function(statuData){
            return printersstatus.post(statuData);
        }
    }

}]);
