angular.module('printa').service('UsersStructuresService', ['Restangular', 'PersonaRestangular', function(Restangular, PersonaRestangular) {

    let usersStructures = PersonaRestangular.all('users_structures');

    return {
        getUsersStructures: function(){
            return usersStructures.getList().$object;
        },
        getUserStructure: function(user_id){
            return PersonaRestangular.one('users_structures').get({user_id : user_id});
        }
    }

}]);
