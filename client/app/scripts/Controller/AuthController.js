angular.module('printa').controller('AuthController', function ($auth, $state, $rootScope, Restangular, PersonaRestangular, UsersStructuresService, StructuresService) {

	var vm = this;

	vm.loginError = false;
	vm.loginErrorText;

	vm.login = function() {

		var suffix = '@maine-et-loire.fr';

		var credentials = {
			email: vm.email + suffix,
			password: vm.password
		}

		$auth.login(credentials).then(function(response) {

			var token = response.data.token;

			// Return an $http request for the now authenticated
			// user so that we can flatten the promise chain
			return PersonaRestangular.one('/api/authenticate/user').get({token : token}).then(function(response) {

				// Stringify the returned data to prepare it
				// to go into local storage
				var user = JSON.stringify(response.user);

				// Set the stringified user data into local storage
				localStorage.setItem('user', user);

				// The user's authenticated state gets flipped to
				// true so we can now show parts of the UI that rely
				// on the user being logged in
				$rootScope.authenticated = true;

				// Putting the user's data on $rootScope allows
				// us to access it anywhere across the app
				$rootScope.currentUser = response.user;

				var userstructure = UsersStructuresService.getUserStructure(response.user.id);

		        userstructure.then(function (response) {

		            var structure = StructuresService.getStructure(response[0].structure_id);

					structure.then(function (response) {

						// Putting the user's structure data on $rootScope allows
						// us to access it anywhere across the app
						$rootScope.currentUserStructure = response;

					});

		        });

				// Everything worked out so we can now redirect to
				// the users state to view the data
				$state.go('home');
			});

			// Handle errors
		}, function(error) {
			vm.loginError = true;
			vm.loginErrorText = error.data.error;

			console.log(error);

			// Affichage du Message d'erreur
			var toastError = document.getElementById('toastError');
			var errorText = error.statusText;
			if(error.status == 401){
				errorText = "Vous n'êtes pas autorisés, vérifiez la saisie de vos identifiants";
			}
			toastError.text = errorText;
			toastError.open();

		});
	}
});
