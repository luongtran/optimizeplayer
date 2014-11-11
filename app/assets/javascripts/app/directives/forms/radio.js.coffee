"use strict"
angular.module("optimizePlayer").directive "radio", ['$timeout', ($timeout) ->
  restrict: 'A',
  require: 'ngModel',
  link: ($scope, $element, attrs, ctrl) ->

    $timeout ->
      $element.find('input.pretty').prettyCheckable()
      $element.find("[value=#{ctrl.$viewValue}]").parent().find("a").addClass("checked")
      $element.on "change", "[name=#{attrs.name}]", ->
        $this = $(this)
        $scope.$apply ->
          ctrl.$setViewValue($this.val())
          callback = $element.find("[value=#{ctrl.$viewValue}]").attr('callback')
          if callback
            eval('$scope.' + callback + '()')
          if attrs.callback
            $scope[attrs.callback]()
    , 0
     
]
