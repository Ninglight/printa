angular.module('printa').service('TrademarksService', ['Restangular', 'MateriaRestangular', function(Restangular, MateriaRestangular) {

    let trademarks = MateriaRestangular.all('trademarks');

    return {
        getTrademarks: function(){
            return trademarks.getList().$object;
        },
        getTrademark: function(id){
            return MateriaRestangular.one('trademarks', id).get();
        },
        newTrademark: function(trademarkData){
            return trademarks.post(trademarkData);
        }
    }

}]);
