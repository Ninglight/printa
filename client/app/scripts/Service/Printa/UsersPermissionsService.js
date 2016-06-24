angular.module('printa').service('UsersPermissionsService', ['Restangular', 'PrintaRestangular', function(Restangular, PrintaRestangular) {

    let userspermissions = PrintaRestangular.all('users_permissions');

    return {
        getUsersPermissions: function(){
            return userspermissions.getList().$object;
        },
        getUserPermission: function(id){
            return PrintaRestangular.one('users_permissions', id).get();
        },
        newUserPermission: function(statuData){
            return userspermissions.post(statuData);
        }
    }

}]);
