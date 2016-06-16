angular.module('printa').service('PrintingsService', ['Restangular', 'PrintaRestangular', function(Restangular, PrintaRestangular) {

    let printings = PrintaRestangular.all('printings');

    return {
        getPrintings: function(){
            return printings.getList().$object;
        },
        getPrinting: function(id){
            return PrintaRestangular.one('printings', id).get();
        },
        newPrinting: function(printingData){
            return printings.post(printingData);
        }

    }

}]);
