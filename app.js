/*global angular */

//! Uncomment to force HTTPS connections
if (window.location.protocol != "https:") window.location.href = "https:" + window.location.href.substring(window.location.protocol.length);

angular.module('proofing.controllers', []);
angular.module('proofing.filters', []);
angular.module('proofing.directives', []);
angular.module('proofing.services', []);

var requiresAuthentication = function(AuthenticationService) {
    return AuthenticationService.authenticated;
};

var $app = angular.module('proofing',[
  'ngRoute',
  'ngCookies',
  'proofing.controllers',
  'proofing.filters',
  'proofing.services'
]).config(['$routeProvider', '$locationProvider', function($routeProvider, $locationProvider) {
/*   $locationProvider.html5Mode(true); */
  $routeProvider.when('/assignments', {
    templateUrl: 'views/assignments.html',
    controller: 'ListingController',
    title: 'Assignments',
    requireAuth: true
  }).when('/assignments/create', {
    templateUrl: 'views/assignments_create.html',
    controller: 'AssignmentController',
    title: 'Create',
    requireAuth: true
  }).when('/assignments/:assignmentId', {
    templateUrl: 'views/assignments_details.html',
    controller: 'AssignmentController',
    title: 'Details',
    requireAuth: true
  }).when('/assignments/:assignmentId/update', {
    templateUrl: 'views/assignments_update.html',
    controller: 'AssignmentController',
    title: 'Update',
    requireAuth: true
  }).when('/assignments/:assignmentId/complete', {
    templateUrl: 'views/assignments_complete.html',
    controller: 'AssignmentController',
    title: 'Complete Assignment',
    requireAuth: true
  }).when('/users', {
    templateUrl: 'views/users.html',
    controller: 'UserController',
    title: 'Users',
    requireAuth: true
  }).when('/users/create', {
    templateUrl: 'views/users_create.html',
    controller: 'UserController',
    title: 'Create',
    requireAuth: true
  }).when('/users/:userId', {
    templateUrl: 'views/users_details.html',
    controller: 'UserController',
    title: 'User Profile',
    requireAuth: true
  }).when('/users/:userId/update', {
    templateUrl: 'views/users_update.html',
    controller: 'UserController',
    title: 'Update',
    requireAuth: true
  }).otherwise({
    templateUrl: 'views/login.html',
    controller: 'LoginController',
    title: "Login"
  });
}]).run(function($rootScope, $location, $cookies, AuthenticationService) {
  $rootScope.$on('$routeChangeStart', function(event, next, current) {
    console.log('requireAuth = ' + next.requireAuth);
    console.log('AuthenticationService.authenticated = '+AuthenticationService.isAuthenticated());
    console.log('cookies.authenticated = '+$cookies.authenticated);
    if (next.requireAuth && !((AuthenticationService.isAuthenticated()===true) || ($cookies.authenticated===true))) {
      console.log('redirect to login');
      // requireAuth = true, authenticated = true: fail
      // requireAuth = true, authendicated = false: true
      // requireAuth = false, authenticated = true: true
      // requireAuth = false, authenticated = false: true
      // User is not logged in
      window.location = "/";
    }
  });
  $rootScope.$on('$routeChangeSuccess', function(event, current, previous) {
    $rootScope.pageTitle = current.title;
  });
});

$app.run(function($rootScope) {
  $rootScope.debugMode = false;
});