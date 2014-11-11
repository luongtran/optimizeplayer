angular.module('optimizePlayer').directive 'ngBlur', ->
  (scope, element, attrs) ->
    element.bind 'blur', ->
      scope.$apply attrs.ngBlur
