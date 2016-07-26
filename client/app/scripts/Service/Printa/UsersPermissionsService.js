angular.module('printa').service('UsersPermissionsService', ['Restangular', 'PrintaRestangular', function(Restangular, PrintaRestangular) {

    let userspermissions = PrintaRestangular.all('users_permissions');

    return {
        getUsersPermissions: function(){
            return userspermissions.getList().$object;
        },
        getUserPermissionByUser: function(user_id){
            return PrintaRestangular.one('users_permissions').get({user_id : user_id});
        },
        getUserPermissionByPermission: function(permission_id){
            return PrintaRestangular.one('users_permissions').get({permission_id : permission_id});
        },
        newUserPermission: function(statuData){
            return userspermissions.post(statuData);
        }
    }

}]);
