/*global $app, $location */

$app.controller('UserController', ['$scope', '$routeParams', '$location', '$http', 'AuthenticationService', function($scope, $routeParams, $location, $http, Auth, transformRequestAsFormPost) {
  $scope.user = null;
  $scope.users = {};
  $scope.currentUser = Auth.getUser();

  $scope.load = function($o) {
    if (($o !== null) && (typeof $o === 'object')) {
      // Assignment passed in directly
      $scope.user = $o;
    } else if (!isNaN($o)) {
      // User ID passed in. Load it from http lookup
      $http.get('/hooks/users.asp?id='+$o).success(function(data) {
        if (data.authenticated===false) {
          $location.path('/login');
        } else if (data.success) {
          $scope.user = data.user;
        } else {

        }

      }).error(function(data) {
      });
    } else {
      // No Assignment passed in
      $scope.user = {};
    }
  };

  $scope.getUsers = function() {
    $http.get('/hooks/users.asp').success(function(data) {
      if (data.authenticated===false) {
          $location.path('/login');
      } else if (data.success) {
        $scope.users = data.users;
      } else {

      }

    }).error(function(data) {
    });
  };

  $scope.createUser = function() {
    $http({
      method: 'POST',
      transformRequest: transformRequestAsFormPost,
      url: '/hooks/users_create.asp',
      params: $scope.user
    }).success(function(data) {
      if (data.authenticated===false) {
          $location.path('/login');
      } else if (data.success) {
        $location.path('/users');
      } else if (data.success===false) {
        alert('User not created: '+data.reason);
      }
    }).error(function(data) {

    });
  };

  $scope.updateUser = function() {
    $http({
      method: 'POST',
      transformRequest: transformRequestAsFormPost,
      url: '/hooks/users_update.asp',
      params: $scope.user
    }).success(function(data) {
      if (data.authenticated===false) {
          $location.path('/login');
      } else if (data.success) {
        console.log('User Updated');
        $location.path('/users');
      } else {
        console.log('User could not be updated');
      }
    }).error(function() {
      console.log('User could not be updated');
    });
  };

  $scope.deleteUser = function(id) {
    $http({
      method: 'POST',
      transformRequest: transformRequestAsFormPost,
      url: '/hooks/users_delete.asp',
      params: $scope.user
    }).success(function(data) {
      if (data.authenticated===false) {
          $location.path('/login');
      } else if (data.success) {
        $location.path('/users');
      } else {

      }
    }).error(function(data) {

    });
  };

  $scope.deauthenticate = function() {
    Auth.deauthenticate().then(function() {
      console.log(Auth.authenticated);
      $location.path('/login');
    });
  };

  if ($routeParams && (typeof $routeParams.assignmentId == "object")) {
    $scope.user = $routeParams.user;
  } else if ($routeParams && !isNaN($routeParams.userId)) {
    $scope.user = $scope.load($routeParams.userId);
  } else {
    $scope.user = {};
  }
}]);