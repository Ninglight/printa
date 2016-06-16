angular.module('printa').service('PagesService', ['Restangular', 'PrintaRestangular', function(Restangular, PrintaRestangular) {

    let pages = PrintaRestangular.all('pages');

    return {
        getPages: function(){
            return pages.getList().$object;
        },
        getPage: function(id){
            return PrintaRestangular.one('pages', id).get();
        },
        newPage: function(pageData){
            return pages.post(pageData);
        }

    }

}]);
