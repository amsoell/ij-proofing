/*global $app */

$app.service('AuthenticationService', ['$http', '$q', '$cookies', function($http, $q, $cookies) {
  var authenticated = false;
  var user = null;
  var deferred = null;

  if ($cookies.authenticated) {
    authenticated = true;
    user = {
     id: $cookies.user_id,
     fullname: $cookies.user_fullname,
     username: $cookies.user_username,
     email: $cookies.user_email,
     administrator: $cookies.user_administrator,
     authenticated: true
    };
  }

  return {
    authenticate: function($user) {
      deferred = $q.defer();
      console.log('auth service:authenticate');
      $http({
        method: 'get',
        url: '/hooks/authenticate.asp',
        params: $user
      }).success(function(data) {
        console.log('auth service:success');
        if (data.authenticated) {
          console.log('auth service:authenticated');
          user                      = data.user;
          authenticated             = true;
          $cookies.authenticated    = true;
          $cookies.user_id = data.user.id;
          $cookies.user_fullname = data.user.fullname;
          $cookies.user_username = data.user.username;
          $cookies.user_email = data.user.email;
          $cookies.user_administrator = data.user.administrator;

          deferred.resolve(data);
        } else {
          console.log('auth service:unauthenticated');
          deferred.resolve({ authenticated: false, reasonCode: data.reasonCode, reason: data.reason });
          return false;
        }
      }).error(function() {
        console.log('auth service:error');
        deferred.resolve({ authenticated: false });
        return false;
      });

      return deferred.promise;
    },
    isAuthenticated: function() {
      return authenticated;
    },
    getUser: function() {
      return user;
    },
    deauthenticate: function() {
      deferred = $q.defer();
      console.log('deauthenticate');

      $http({
        method: 'get',
        url: '/hooks/deauthenticate.asp'
      }).success(function(data) {
        console.log('deauth service:success');
        if (!data.authenticated) {
          console.log('deauth service:deauthenticated');
          user                          = null;
          authenticated                 = false;
          $cookies.authenticated        = false;
          $cookies.user_id              = null;
          $cookies.user_fullname        = null;
          $cookies.user_username        = null;
          $cookies.user_email           = null;
          $cookies.user_administrator   = null;

          deferred.resolve(data);
        } else {
          console.log('deauth service:failed');
          deferred.resolve({ authenticated: false });
          return false;
        }
      });

      deferred.resolve({ success: true });
      return deferred.promise;
    }
  };
}]);