angular.module('printa').service('OidsService', ['Restangular', 'PrintaRestangular', function(Restangular, PrintaRestangular) {

    let oids = PrintaRestangular.all('oids');

    return {
        getOids: function(){
            return oids.getList().$object;
        },
        getOid: function(id){
            return PrintaRestangular.one('oids', id).get();
        },
        newOid: function(oidData){
            return oids.post(oidData);
        }

    }

}]);
