angular.module('printa').service('ActionsService', ['Restangular', 'PrintaRestangular', function(Restangular, PrintaRestangular) {

    let actions = PrintaRestangular.all('actions');

    return {
        getActions: function(){
            return actions.getList().$object;
        },
        getAction: function(id){
            return PrintaRestangular.one('actions', id).get();
        },
        newAction: function(actionData){
            return actions.post(actionData);
        }

    }

}]);
