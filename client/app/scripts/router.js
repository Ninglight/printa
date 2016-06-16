angular.module('printa').config(['$stateProvider', '$urlRouterProvider', function($stateProvider, $urlRouterProvider) {

    $urlRouterProvider.otherwise('/home');

    $stateProvider
    .state('home', {
        url: '/home',
        templateUrl: '../templates/home.html'
    })
    .state('search', {
        url: '/search',
        templateUrl: '../templates/search.html'
    })
    .state('view', {
        url: '/view',
        controller: 'PrinterController',
        templateUrl: '../templates/view.html'
    })
    .state('install', {
        url: '/install',
        templateUrl: '../templates/install.html'
    })
    .state('manage', {
        url: '/manage',
        templateUrl: '../templates/manage.html'
    })

}]);
