"use strict"
angular.module("optimizePlayer").directive "strackbar", ["$timeout", ($timeout) ->
  restrict: "A"
  require: "ngModel"
  scope: true
  link: ($scope, $element, $attrs, ctrl) ->
    $timeout (->
      $element.strackbar
        style: "style3"
        defaultValue: (if ($attrs.defaultValue <= 1) then $attrs.defaultValue * 100 else $attrs.defaultValue)
        animate: true
        ticks: false
        labels: false
        sliderHeight: 5
        sliderWidth: $attrs.sliderWidth
        trackerHeight: 24
        trackerWidth: 17
        minValue: 0
        maxValue: 101
        callback: (val) ->
          $scope.$apply ->
            ctrl.$setViewValue val / 100


    ), 2000
]