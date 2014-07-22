/*global $app */

$app.controller('LoginController', ['$scope', '$http', '$location', "$cookies", 'AuthenticationService', function($scope, $http, $location, $cookies, Auth) {
  $scope.user = {
    username: null,
    password: null
  };
  $scope.errorCode = null;
  $scope.errorMessage = null;
  
  $scope.authenticated = null;
  
  $scope.authenticate = function() {
    $scope.errorCode = null;
    $scope.errorMessage = null;    
    $scope.authenticated = null;
  
    Auth.authenticate($scope.user).then(function (data) {
      console.log('then');
      if (data.authenticated) {
        console.log('authenticated');
        $scope.errorCode = null;
        $scope.errorMessage = null;
        $location.path('/assignments');
      } else {
        console.log('unauthenticated');
        $scope.errorCode = data.reasonCode;
        $scope.errorMessage = data.reason;

        $scope.user = {
          username: null,
          password: null
        };
        $scope.authenticated = null;


      }
    });
  };

}]);