$app.controller('AssignmentController', function($scope, $routeParams, $location, $http) { 
  $scope.load = function($o) {
    if (($o !== null) && (typeof $o === 'object')) {
      // Assignment passed in directly
      $scope.assignment = $o;
    } else if (!isNaN($o)) {
      // Assignment ID passed in. Load it from http lookup
      $http.get('/hooks/assignments.asp?id='+$o).success(function(data) {
        if (data.success) {
          $scope.assignment = data.assignment;          
          console.log("loaded:");
          console.log($scope.assignment);
        } else {
          
        }

      }).error(function(data) {
      });
    } else {
      // No Assignment passed in
      $scope.assignment = {}
    }
  } 
  
  $scope.createAssignment = function() {
    console.log($scope.assignment);
    $http({
      method: 'GET',
      url: '/hooks/assignments_create.asp',
      params: $scope.assignment
    }).success(function(data) {
      if (data.success) {
        $location.path('/assignments');
      } else {
        
      }
    }).error(function(data) {
      
    })
  }
  
  $scope.updateAssignment = function() {
    $http({
      method: 'GET',
      url: '/hooks/assignments_update.asp', 
      params: $scope.assignment
    }).success(function(data) {
      if (data.success) {
        console.log('Assignment Updated');  
        $location.path('/assignments');              
      } else {
        console.log('Assignment could not be updated');      
      }
    }).error(function() {
      console.log('Assignment could not be updated');
    })
  }
  
  if ($routeParams && (typeof $routeParams.assignmentId == "object")) {
    $scope.assignment = $routeParams.assignment
  } else if ($routeParams && !isNaN($routeParams.assignmentId)) {
    $scope.assignment = $scope.load($routeParams.assignmentId);
  } else {
    $scope.assignment = {}
  }
});