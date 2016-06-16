angular.module('printa').service('ColorsService', ['Restangular', 'PrintaRestangular', function(Restangular, PrintaRestangular) {

    let colors = PrintaRestangular.all('colors');

    return {
        getColors: function(){
            return colors.getList().$object;
        },
        getColor: function(id){
            return PrintaRestangular.one('colors', id).get();
        },
        newColor: function(colorData){
            return colors.post(colorData);
        }

    }

}]);
