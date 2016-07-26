angular.module('printa').controller('HomeTableController', function ($scope, PrintersService, ModelsPrintersService, ModelsService, StatusService, TrademarksService){

    var printer = PrintersService.getPrinter(1);
    $scope.printer = printer.$object;

    printer.then(function (result) {

        var modelprinter = ModelsPrintersService.getModelPrinter(result.id);

        modelprinter.then(function (result) {

            var model = ModelsService.getModel(result[0].model_id);

            model.then(function (result) {

                var trademark = TrademarksService.getTrademark(result[0].trademark_id);
                $scope.model = result[0];
                $scope.model.trademark_id = trademark.$object;

            });
        });

        var status = StatusService.getStatu(result.status_id);
        $scope.printer.status_id = status.$object;

    });

});
