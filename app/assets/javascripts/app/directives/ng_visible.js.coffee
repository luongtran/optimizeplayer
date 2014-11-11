angular.module('optimizePlayer').directive "ngVisible", ->
  (scope, element, attr) ->
    scope.$watch attr.ngVisible, (visible) ->
      element.css "visibility", (if visible then "visible" else "hidden")
