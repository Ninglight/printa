angular.module('printa').service('CommandsService', ['Restangular', 'PrintaRestangular', function(Restangular, PrintaRestangular) {

    let commands = PrintaRestangular.all('commands');

    return {
        getCommands: function(){
            return commands.getList().$object;
        },
        getCommand: function(id){
            return PrintaRestangular.one('commands', id).get();
        },
        newCommand: function(commandData){
            return commands.post(commandData);
        }

    }

}]);
