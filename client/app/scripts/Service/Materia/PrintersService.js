angular.module('printa').service('PrintersService', ['Restangular', 'MateriaRestangular', function(Restangular, MateriaRestangular) {

    let printers = MateriaRestangular.all('printers');

    return {
        getPrinters: function(){
            return printers.getList().$object;
        },
        getPrinter: function(id){
            return MateriaRestangular.one('printers', id).get();
        },
        getPrinterByLocation: function(id){
            return MateriaRestangular.one('printers', id).get({location_id : location_id});
        },
        newPrinter: function(printerData){
            return printers.post(printerData);
        }
    }

}]);
