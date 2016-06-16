angular.module('printa').service('formatsService', ['Restangular', 'PrintaRestangular', function(Restangular, PrintaRestangular) {

    let formats = PrintaRestangular.all('formats');

    return {
        getFormats: function(){
            return formats.getList().$object;
        },
        getFormat: function(id){
            return PrintaRestangular.one('formats', id).get();
        },
        newFormat: function(formatData){
            return formats.post(formatData);
        }

    }

}]);
