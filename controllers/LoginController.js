$app.controller('LoginController', ['$scope', '$http', '$location', "$cookies", 'AuthenticationService', function($scope, $http, $location, $cookies, Auth) {
  $scope.user = {
    username: null,
    password: null
  };
  $scope.authenticated = null;
  
  $scope.authenticate = function() {
    Auth.authenticate($scope.user).then(function (data) {
      if (data.authenticated) {
        console.log('(authenticated)');
        $location.path('/assignments');
      } else {
        console.log('(unauthenticated)');
      }
    });
  }

}]);