angular.module("angular-bootstrap-select", []).directive "selectpicker", [ "$timeout", "$parse", "$rootScope", ($timeout, $parse, $rootScope) ->
  restrict: "A"
  require: "?ngModel"
  priority: 1001
  compile: (tElement, tAttrs, transclude) ->
    (scope, element, attrs, ngModel) ->
      return  if angular.isUndefined(ngModel)
      scope.$watch attrs.ngModel, ->
        $timeout ->
          element.selectpicker()
          element.selectpicker "refresh"
        , 1000

      ngModel.$render = ->
        $timeout ->
          element.selectpicker()
          element.selectpicker "refresh"
        , 1000

      ngModel.$viewValue = element.val()
 ]