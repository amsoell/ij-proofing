$app.directive('confirm', function() {
  return {
    priority: -100,
    restrict: 'A',
    link: function (scope, element, attrs) {
      console.log('confirm...');
      var msg = attrs.confirm || "Are you sure?";

      element.bind('click', function (event) {
        if (!confirm(msg)) {
          console.log('cancel');
          event.stopPropagation();
          event.preventDefault();
        }
      });
    }
  }
}).directive('cancel', function($window) {
  return {
    restrict: 'EA',
    link: function (scope, element, attrs) {
      element.bind('click', function (event) {
        $window.history.back();
      })
    }
  }
});