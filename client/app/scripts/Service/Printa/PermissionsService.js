angular.module('printa').service('PermissionsService', ['Restangular', 'PrintaRestangular', function(Restangular, PrintaRestangular) {

    let permissions = PrintaRestangular.all('permissions');

    return {
        getPermissions: function(){
            return permissions.getList().$object;
        },
        getPermission: function(id){
            return PrintaRestangular.one('permissions', id).get();
        },
        newPermission: function(permissionData){
            return permissions.post(permissionData);
        }
    }

}]);
