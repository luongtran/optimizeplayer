angular.module("optimizePlayer").directive "incDecField", ->
  scope: {}
  link: ($scope, $element, $attrs, ngModel) ->
    $scope.price = $attrs.price
    $scope.quantity = 0
    $scope.field = $("#" + $attrs.fieldContainer + " [name=quantity]")

    $scope.$watch 'quantity', (q) ->
      console.log(q)
      $scope.field.val(q)
