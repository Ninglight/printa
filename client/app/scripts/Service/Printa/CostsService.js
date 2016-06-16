angular.module('printa').service('CostsService', ['Restangular', 'PrintaRestangular', function(Restangular, PrintaRestangular) {

    let costs = PrintaRestangular.all('costs');

    return {
        getCosts: function(){
            return costs.getList().$object;
        },
        getCost: function(id){
            return PrintaRestangular.one('costs', id).get();
        },
        newCost: function(costData){
            return costs.post(costData);
        }

    }

}]);
