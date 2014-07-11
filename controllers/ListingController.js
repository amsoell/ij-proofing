$app.controller('ListingController', ['$scope', '$http', function($scope, $http) {
  $scope.assignments = null;
  
  $scope.getAssignments = function() {
    $http.get('/hooks/assignments.asp').success(function(data) {
      if (data.success) {
        $scope.assignments = data.assignments;        
      } else {
        
      }

    }).error(function(data) {
    });
  }
}]);