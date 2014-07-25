/*global $app, $location */

$app.controller('AssignmentController', ['$scope', '$routeParams', '$location', '$http', 'AuthenticationService', function($scope, $routeParams, $location, $http, Auth, transformRequestAsFormPost) { 
  $scope.user = Auth.getUser();

  $scope.load = function($o) {
    if (($o !== null) && (typeof $o === 'object')) {
      // Assignment passed in directly
      $scope.assignment = $o;
    } else if (!isNaN($o)) {
      // Assignment ID passed in. Load it from http lookup
      $http.get('/hooks/assignments.asp?id='+$o).success(function(data) {
        if (data.authenticated===false) {
          $location.path('/login');
        } else if (data.success) {
          $scope.assignment = data.assignment;      
          
          var user = Auth.getUser();
          console.log("User:");
          console.log(user);
          console.log("Item:");
          console.log(data);
          if (user.id==data.assignment.created_by.id) {
            $scope.assignment.isMine = true;
          }
          if (user.id==data.assignment.assigned_to.id) {
            $scope.assignment.isClaimedByMe = true;
          }
          console.log(user);
        } else {
          
        }

      }).error(function(data) {
      });
    } else {
      // No Assignment passed in
      $scope.assignment = {};
    }
  };
  
  $scope.createAssignment = function() {
    console.log($scope.assignment);
    $http({
      method: 'POST',
      transformRequest: transformRequestAsFormPost,
      url: '/hooks/assignments_create.asp',
      params: $scope.assignment
    }).success(function(data) {
      if (data.authenticated===false) {
          $location.path('/login');
      } else if (data.success) {
        $location.path('/assignments');
      } else {
        
      }
    }).error(function(data) {
      
    });
  };
  
  $scope.updateAssignment = function() {
    $http({
      method: 'POST',
      transformRequest: transformRequestAsFormPost,
      url: '/hooks/assignments_update.asp', 
      params: $scope.assignment
    }).success(function(data) {
      if (data.authenticated===false) {
          $location.path('/login');
      } else if (data.success) {
        console.log('Assignment Updated');  
        $location.path('/assignments');              
      } else {
        console.log('Assignment could not be updated');      
      }
    }).error(function() {
      console.log('Assignment could not be updated');
    });
  };
  
  $scope.deleteAssignment = function(id) {
    $http({
      method: 'POST',
      transformRequest: transformRequestAsFormPost,
      url: '/hooks/assignments_delete.asp',
      params: {
        id: id
      }
    }).success(function(data) {
      if (data.authenticated===false) {
          $location.path('/login');
      } else if (data.success) {
        $location.path('/assignments');
      } else {
        
      }
    }).error(function(data) {
      
    });
  };
  
  $scope.claimAssignment = function() {
    $http({
      method: 'POST',
      transformRequest: transformRequestAsFormPost,
      url: '/hooks/assignments_claim.asp',
      params: {
        id: $scope.assignment.id
      }
    }).success(function(data) {
      if (data.authenticated===false) {
        $location.path('/login');
      } else if (data.success) {
        $scope.assignment = data.assignment;//.assigned_to      = data.assigned_to;
        $scope.assignment.isClaimedByMe    = true;
      } else {
        
      }
    }).error(function(data) {
      
    });
  };
  
  $scope.unclaimAssignment = function() {
    $http({
      method: 'POST',
      transformRequest: transformRequestAsFormPost,
      url: '/hooks/assignments_unclaim.asp',
      params: {
        id: $scope.assignment.id
      }
    }).success(function(data) {
      if (data.authenticated===false) {
        $location.path('/login');
      } else if (data.success) {
        $scope.assignment.assigned_to       = null;
        $scope.assignment.isClaimedByMe    = false;
      } else {
        
      }
    }).error(function(data) {
      
    });
  };  
  
  $scope.completeAssignment = function() {
    $http({
      method: 'POST',
      transformRequest: transformRequestAsFormPost,
      url: '/hooks/assignments_complete.asp', 
      params: $scope.assignment
    }).success(function(data) {
      if (data.authenticated===false) {
          $location.path('/login');
      } else if (data.success) {
        console.log('Assignment Completed');  
        $location.path('/assignments');              
      } else {
        console.log('Assignment could not be completed');      
      }
    }).error(function() {
      console.log('Assignment could not be completed');
    });
  };
  
  if ($routeParams && (typeof $routeParams.assignmentId == "object")) {
    $scope.assignment = $routeParams.assignment;
  } else if ($routeParams && !isNaN($routeParams.assignmentId)) {
    $scope.assignment = $scope.load($routeParams.assignmentId);
  } else {
    $scope.assignment = {};
  }
}]);