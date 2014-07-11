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
    requireAuth: true
  }).when('/assignments/create', {
    templateUrl: 'views/assignments_create.html',
    controller: 'AssignmentController',
    requireAuth: true
  }).when('/assignments/:assignmentId', {
    templateUrl: 'views/assignments_details.html',
    controller: 'AssignmentController',
    requireAuth: true
  }).when('/assignments/:assignmentId/update', {
    templateUrl: 'views/assignments_update.html',
    controller: 'AssignmentController',
    requireAuth: true
  }).otherwise({
    templateUrl: 'views/login.html',
    controller: 'LoginController'
  });
}]).run(function($rootScope, $location, $cookies, AuthenticationService) {
  $rootScope.$on('$routeChangeStart', function(event, next, current) {
    if (!(next.requireAuth && (AuthenticationService.authenticated || $cookies.authenticated))) {
    console.log('redirecting to login');
      // requireAuth = true, authenticated = true: fail
      // requireAuth = true, authendicated = false: true
      // requireAuth = false, authenticated = true: true
      // requireAuth = false, authenticated = false: true
      // User is not logged in
      $location.path('/');
    }
  })
});