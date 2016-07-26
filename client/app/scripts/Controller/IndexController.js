angular.module('printa').controller('UsersController', function ($scope, UsersService, UsersStructuresService, StructuresService){

    var user = UsersService.getUser('v.bourreau');

    user.then(function (result) {

        $scope.user = result[0];
        var userstructure = UsersStructuresService.getUserStructureByUser(result.id);

        userstructure.then(function (result) {

            var structure = StructuresService.getStructure(result[0].structure_id);
            $scope.structure = structure.$object;

        });

    });

});
