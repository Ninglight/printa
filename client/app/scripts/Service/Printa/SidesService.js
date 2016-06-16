angular.module('printa').service('SidesService', ['Restangular', 'PrintaRestangular', function(Restangular, PrintaRestangular) {

    let sides = PrintaRestangular.all('sides');

    return {
        getSides: function(){
            return sides.getList().$object;
        },
        getSide: function(id){
            return PrintaRestangular.one('sides', id).get();
        },
        newSide: function(sideData){
            return sides.post(sideData);
        }

    }

}]);
