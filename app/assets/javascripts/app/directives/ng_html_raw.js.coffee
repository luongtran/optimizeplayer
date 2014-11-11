angular.module("optimizePlayer").directive "ngHtmlRaw", ->
  (scope, element, attrs) ->
    scope.$watch attrs.ngHtmlRaw, (value) ->
      element[0].innerHTML = value
