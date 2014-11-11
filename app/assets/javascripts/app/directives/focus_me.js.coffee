angular.module('optimizePlayer').directive "focusMe", ($timeout, $parse) ->
  link: (scope, element, attrs) ->
    model = $parse(attrs.focusMe)
    scope.$watch model, (value) ->
      if value is true
        $timeout ->
          element[0].focus()
          element[0].select()
