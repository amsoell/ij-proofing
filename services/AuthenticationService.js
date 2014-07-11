$app.factory('AuthenticationService', ['$http', '$q', '$cookies', function($http, $q, $cookies) {
  var serviceInstance = {
    authenticated: false,
    user: null,    
  };
  
  var deferred = $q.defer();
  
  serviceInstance.authenticate = function($user) {
    $http.post('/hooks/authenticate.asp', $user).success(function(data) {
      if (data.authenticated) {
        this.user = data.user;
        this.authenticated = true;
        $cookies.authenticated = true;
        $cookies.user = data.user;
        
        deferred.resolve(data);
      } else {
        deferred.resolve({ authenticated: false });        
        return false;
      }
    }).error(function() {
      deferred.resolve({ authenticated: false });
      return false;
    });
    
    return deferred.promise;
  }
  
  return serviceInstance;
}]);