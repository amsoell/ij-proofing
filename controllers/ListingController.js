/*global $app, $location */

$app.controller('ListingController', ['$scope', '$http', 'AuthenticationService', function($scope, $http, Auth) {
  $scope.assignments = null;
  $scope.user = Auth.getUser();

  $scope.getAssignments = function() {
    $http.get('/hooks/assignments.asp').success(function(data) {
      if (data.authenticated===false) {
          $location.path('/login');
      } else if (data.success) {
        $scope.assignments = data.assignments;
      } else {

      }

    }).error(function(data) {
    });
  };

  $scope.predicate = '-description';
}]);