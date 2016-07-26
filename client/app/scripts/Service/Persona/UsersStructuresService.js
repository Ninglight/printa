angular.module('printa').service('UsersStructuresService', ['Restangular', 'PersonaRestangular', function(Restangular, PersonaRestangular) {

    let usersStructures = PersonaRestangular.all('users_structures');

    return {
        getUsersStructures: function(){
            return usersStructures.getList().$object;
        },
        getUserStructureByUser: function(user_id){
            return PersonaRestangular.one('users_structures').get({user_id : user_id});
        },
        getUserStructureByStructure: function(structure_id){
            return PersonaRestangular.one('users_structures').get({structure_id : structure_id});
        }
    }

}]);
