angular.module('printa').controller('PrinterController', function ($scope, LocationsService, PrintersService) {

    var vm = this;
    $scope.printers = null;

    var locations = LocationsService.getLocations();

    $scope.locations = locations;

    vm.load = function() {

        var location_id = vm.selectedLocation;

        var printers = PrintersService.getPrinterByLocation(location_id);

        $scope.printers = printers;

    }
});
