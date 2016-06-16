angular.module('printa').controller('UsersController', function ($scope, UsersService){

    $scope.users = UsersService.getUsers();

});

angular.module('printa').controller('UserController', function ($scope, UsersService, UsersStructuresService, StructuresService){

    var user = UsersService.getUser(1);
    $scope.user = user.$object;

    user.then(function (result) {

        var userstructure = UsersStructuresService.getUserStructure(result.id);

        userstructure.then(function (result) {

            var structure = StructuresService.getStructure(result[0].structure_id);
            $scope.structure = structure.$object;

        });

    });

});
