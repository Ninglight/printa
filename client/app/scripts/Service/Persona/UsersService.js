angular.module('printa').service('UsersService', ['Restangular', 'PersonaRestangular', function(Restangular, PersonaRestangular) {

    let users = PersonaRestangular.all('users');

    return {
        getUsers: function(){
            return users.getList().$object;
        },
        getUser: function(id){
            return PersonaRestangular.one('users', id).get();
        }
    }

}]);
