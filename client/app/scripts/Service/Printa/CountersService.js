angular.module('printa').service('CountersService', ['Restangular', 'PrintaRestangular', function(Restangular, PrintaRestangular) {

    let counters = PrintaRestangular.all('counters');

    return {
        getCounters: function(){
            return counters.getList().$object;
        },
        getCounter: function(id){
            return PrintaRestangular.one('counters', id).get();
        },
        newCounter: function(counterData){
            return counters.post(counterData);
        }

    }

}]);
