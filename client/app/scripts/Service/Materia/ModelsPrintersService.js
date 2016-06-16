angular.module('printa').service('ModelsPrintersService', ['Restangular', 'MateriaRestangular', function(Restangular, MateriaRestangular) {

    let modelsPrinters = MateriaRestangular.all('models_printers');

    return {
        getModelsPrinters: function(){
            return modelsPrinters.getList().$object;
        },
        getModelPrinter: function(printer_id){
            return MateriaRestangular.one('models_printers').get({printer_id : printer_id});
        },
        newModelPrinter: function(modelPrinterData){
            return modelsPrinters.post(modelPrinterData);
        }
    }

}]);
