angular.module('printa').config(['$stateProvider', '$urlRouterProvider', '$authProvider', '$httpProvider', '$provide', function($stateProvider, $urlRouterProvider, $authProvider, $httpProvider, $provide) {

    function redirectWhenLoggedOut($q, $injector) {

        return {

            responseError: function(rejection) {

                // Need to use $injector.get to bring in $state or else we get
                // a circular dependency error
                var $state = $injector.get('$state');

                // Instead of checking for a status code of 400 which might be used
                // for other reasons in Laravel, we check for the specific rejection
                // reasons to tell us if we need to redirect to the login state
                var rejectionReasons = ['token_not_provided', 'token_expired', 'token_absent', 'token_invalid'];

                // Loop through each rejection reason and redirect to the login
                // state if one is encountered
                angular.forEach(rejectionReasons, function(value, key) {

                    if(rejection.error === value) {

                        // If we get a rejection corresponding to one of the reasons
                        // in our array, we know we need to authenticate the user so
                        // we can remove the current user from local storage
                        localStorage.removeItem('user');

                        // Send the user to the auth state so they can login
                        $state.go('auth');
                    }
                });

                return $q.reject(rejection);
            }
        }
    }

    // Setup for the $httpInterceptor
    $provide.factory('redirectWhenLoggedOut', redirectWhenLoggedOut);

    // Push the new factory onto the $http interceptor array
    $httpProvider.interceptors.push('redirectWhenLoggedOut');

    // Satellizer configuration that specifies which API
    // route the JWT should be retrieved from
    $authProvider.loginUrl = 'http://localhost:8000/api/authenticate';
    $authProvider.httpInterceptor = false;
    $authProvider.supportsCredentials = true;

    // Redirect to the auth state if any other states
    // are requested other than users
    $urlRouterProvider.otherwise('/auth');

    $stateProvider
    .state('home', {
        url: '/home',
        views: {
            'header' : {
                templateUrl: '../templates/headerView.html',
                controller: function($scope){
                    $scope.name = "Bienvenue sur Printa",
                    $scope.subname = "Réconciliez vous avec les imprimantes";
                    $scope.icon = true;
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
                templateUrl: '../templates/headerView.html',
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
                templateUrl: '../templates/headerView.html',
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
                templateUrl: '../templates/headerView.html',
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
                templateUrl: '../templates/headerView.html',
                controller: function($scope){
                    $scope.name = "Administration des données"
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
    .state('auth', {
        url: '/auth',
        views: {
            'main' : {
                templateUrl: '../templates/authView.html',
                controller: 'AuthController as auth'
            },
            'left' : {
                templateUrl: '../templates/authLeftView.html'
            }
        }
    });

}]).run(function($rootScope, $state, Restangular, PersonaRestangular, UsersStructuresService, StructuresService) {

    // $stateChangeStart is fired whenever the state changes. We can use some parameters
    // such as toState to hook into details about the state as it is changing
    $rootScope.$on('$stateChangeStart', function(event, toState) {

        // Grab the user from local storage and parse it to an object
        var user = JSON.parse(localStorage.getItem('user'));

        // If there is any user data in local storage then the user is quite
        // likely authenticated. If their token is expired, or if they are
        // otherwise not actually authenticated, they will be redirected to
        // the auth state because of the rejected request anyway
        if(user) {

            // The user's authenticated state gets flipped to
            // true so we can now show parts of the UI that rely
            // on the user being logged in
            $rootScope.authenticated = true;

            // Putting the user's data on $rootScope allows
            // us to access it anywhere across the app. Here
            // we are grabbing what is in local storage
            $rootScope.currentUser = user;

            var userstructure = UsersStructuresService.getUserStructure(user.id);

            userstructure.then(function (response) {

                var structure = StructuresService.getStructure(response[0].structure_id);

                structure.then(function (response) {

                    // Putting the user's structure data on $rootScope allows
                    // us to access it anywhere across the app
                    $rootScope.currentUserStructure = response;

                });

            });

            // If the user is logged in and we hit the auth route we don't need
            // to stay there and can send the user to the main state
            if(toState.name === "auth") {

                // Preventing the default behavior allows us to use $state.go
                // to change states
                event.preventDefault();

                // go to the "main" state which in our case is users
                $state.go('home');
            }
        }
    });
});
