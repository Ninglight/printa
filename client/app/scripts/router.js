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
    .state('manage.error', {
        url: '/error',
        templateUrl: '../templates/manage/error.html'
    })
    .state('manage.cost', {
        url: '/cost',
        templateUrl: '../templates/manage/cost.html'
    })
    .state('manage.snmp', {
        url: '/snmp',
        templateUrl: '../templates/manage/snmp.html'
    })
    .state('manage.counter', {
        url: '/counter',
        templateUrl: '../templates/manage/counter.html'
    })
    .state('manage.page', {
        url: '/page',
        templateUrl: '../templates/manage/page.html'
    })
    .state('manage.printer', {
        url: '/printer',
        templateUrl: '../templates/manage/printer.html'
    })
    .state('manage.user', {
        url: '/user',
        templateUrl: '../templates/manage/user.html'
    })

}]);
