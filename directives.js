/*global $app, $location */

$app.directive('confirmClick', function() {
  return {
    priority: -100,
    restrict: 'A',
    link: function ($scope, $element, $attr) {
      var msg = $attr.title || "Are you sure?";
      var clickAction = $attr.confirmClick;
      $element.bind('click', function (event) {
        if (confirm(msg)) {
          console.log('deleting');
          $scope.$eval(clickAction);
        }
      });
    }    
  };
}).directive('cancelClick', function($window) {
  return {
    restrict: 'EA',
    link: function (scope, element, attrs) {
      element.bind('click', function (event) {
        $window.history.back();
      });
    }
  };
}).directive('debug', function($rootScope) {
  return {
    restrict: 'EA',
    replace: true,
    transclude: true,
    template: ($rootScope.debugMode?'<pre class="debug" ng-transclude></pre>':'')
  };
}).directive("repeatPassword", function() {
  return {
    require: "ngModel",
    link: function(scope, elem, attrs, ctrl) {
      var otherInput = elem.inheritedData("$formController")[attrs.repeatPassword];

      ctrl.$parsers.push(function(value) {
        if(value === otherInput.$viewValue) {
          ctrl.$setValidity("repeat", true);
          return value;
        }
        ctrl.$setValidity("repeat", false);
      });

      otherInput.$parsers.push(function(value) {
        ctrl.$setValidity("repeat", value === ctrl.$viewValue);
        return value;
      });
    }
  };
});