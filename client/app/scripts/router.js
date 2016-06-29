angular.module('printa').config(['$stateProvider', '$urlRouterProvider', function($stateProvider, $urlRouterProvider) {

    $urlRouterProvider.otherwise('/home');

    $stateProvider
    .state('home', {
        url: '/home',
        views: {
            'header' : {
                templateUrl: '../templates/header.html',
                controller: function($scope){
                    $scope.name = "Bienvenue sur Printa",
                    $scope.subname = "Réconciliez vous avec les imprimantes"
                }
            },
            'left' : {
                templateUrl: '../templates/left.html'
            },
            'main' : {
                templateUrl: '../templates/home.html'
            }
        }
    })
    .state('search', {
        url: '/search',
        views: {
            'header' : {
                templateUrl: '../templates/header.html',
                controller: function($scope){
                    $scope.name = "Recherche d'imprimante",
                    $scope.subname = "Retrouver les imprimantes de votre service";
                }
            },
            'left' : {
                templateUrl: '../templates/left.html'
            },
            'main' : {
                templateUrl: '../templates/search.html'
            }
        }
    })
    .state('view', {
        url: '/view',
        controller: 'PrinterController',
        views: {
            'header' : {
                templateUrl: '../templates/header.html',
                controller: function($scope){
                    $scope.name = "Statistique d'impression",
                    $scope.subname = "Visualisation les données d'impression";
                }
            },
            'left' : {
                templateUrl: '../templates/left.html'
            },
            'main' : {
                templateUrl: '../templates/view.html'
            }
        }
    })
    .state('install', {
        url: '/install',
        views: {
            'header' : {
                templateUrl: '../templates/header.html',
                controller: function($scope){
                    $scope.name = "Mise en place des imprimantes",
                    $scope.subname = "Suivi de l'installation des imprimantes";
                }
            },
            'left' : {
                templateUrl: '../templates/left.html'
            },
            'main' : {
                templateUrl: '../templates/install.html'
            }
        }
    })
    .state('manage', {
        url: '/manage',
        views: {
            'header' : {
                templateUrl: '../templates/header.html',
                controller: function($scope){
                    $scope.name = "Administration des données",
                    $scope.subname = "Gestion des données d'impression";
                }
            },
            'left' : {
                templateUrl: '../templates/left.html'
            },
            'main' : {
                templateUrl: '../templates/manage.html'
            }
        }
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
    .state('login', {
        url: '/login',
        views: {
            'left' : {
                templateUrl: '../templates/leftLogin.html'
            },
            'main' : {
                templateUrl: '../templates/login.html'
            }
        }

    })

}]);
