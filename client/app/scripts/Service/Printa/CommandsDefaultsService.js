angular.module('printa').service('CommandsDefaultsService', ['Restangular', 'PrintaRestangular', function(Restangular, PrintaRestangular) {

    let commandsDefaults = PrintaRestangular.all('command_defaults');

    return {
        getCommandsDefaults: function(){
            return commandDefaults.getList().$object;
        },
        getCommandDefault: function(id){
            return PrintaRestangular.one('command_defaults', id).get();
        },
        newCommandDefault: function(commandDefaultData){
            return commandDefaults.post(commandDefaultData);
        }

    }

}]);
