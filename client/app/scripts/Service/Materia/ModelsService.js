angular.module('printa').service('ModelsService', ['Restangular', 'MateriaRestangular', function(Restangular, MateriaRestangular) {

    let models = MateriaRestangular.all('models');

    return {
        getModels: function(){
            return models.getList().$object;
        },
        getModel: function(id){
            return MateriaRestangular.one('models', id).get();
        },
        newModel: function(modelData){
            return models.post(modelData);
        }
    }

}]);
