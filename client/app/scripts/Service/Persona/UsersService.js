angular.module('printa').service('UsersService', ['$rootScope', 'Restangular', 'PersonaRestangular', 'UsersStructuresService', 'StructuresService', 'UsersPermissionsService', 'PermissionsService', function($rootScope, Restangular, PersonaRestangular, UsersStructuresService, StructuresService, UsersPermissionsService, PermissionsService) {

    let users = PersonaRestangular.all('users');

    return {
        getUsers: function(){
            return users.getList().$object;
        },
        getUser: function(login){
            return PersonaRestangular.one('users').get({login : login});
        },
        getAdditionnalUserDataToRootScope: function(user){

            $rootScope.invite = true;
            $rootScope.operate = false;
            $rootScope.network = false;
            $rootScope.material = false;
            $rootScope.admin = false;

            // Putting the user's data on $rootScope allows
            // us to access it anywhere across the app
            $rootScope.currentUser = user;

            UsersStructuresService.getUserStructureByUser(user.id).then(function (response) {

                StructuresService.getStructure(response[0].structure_id).then(function (response) {

                    // Putting the user's structure data on $rootScope allows
                    // us to access it anywhere across the app
                    $rootScope.currentUserStructure = response;

                }, function(){
                    // Si le requête à la base de données à échoué, on initalise quand même les variables d'envirronement
                    $rootScope.currentUserStructure = null;

                });

            }, function(){
                // Si le requête à la base de données à échoué, on initalise quand même les variables d'envirronement
                $rootScope.currentUserStructure = null;

            });

            UsersPermissionsService.getUserPermissionByUser(user.id).then(function (response) {

                PermissionsService.getPermission(response[0].permission_id).then(function (response) {

                    // Putting the user's permission data on $rootScope allows
                    // us to access it anywhere across the app

                    if(response.name == 'Opérateur Système') {
                        $rootScope.operate = true;
                        $rootScope.invite = false;
                    }
                    if(response.name == 'Réseau') {
                        $rootScope.network = true;
                        $rootScope.invite = false;
                    }
                    if(response.name == 'Matériel') {
                        $rootScope.material = true;
                        $rootScope.invite = false;
                    }
                    if(response.name == 'Administrateur') {
                        $rootScope.admin = true;
                        $rootScope.invite = false;
                    }

                });

            }, function(){

                // Si le requête à la base de données à échoué, on initalise quand même les variables d'envirronement
                $rootScope.invite = true;
                $rootScope.operate = false;
                $rootScope.network = false;
                $rootScope.material = false;
                $rootScope.admin = false;

            });
        }
    }

}]);
