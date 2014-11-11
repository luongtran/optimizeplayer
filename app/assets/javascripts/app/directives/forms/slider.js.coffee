"use strict"
angular.module("optimizePlayer").directive "slider", ["$parse", ($parse) ->
  restrict: "A"
  require: "ngModel"
  scope: true
  link: (scope, element, attrs, ngModel) ->
    model = $parse(attrs.ngModel)
    slider = $(element[0]).slider()
    slider.on "slide", (ev) ->
      model.assign scope, ev.value / 100
      scope.$apply()

    scope.$watch attrs.ngModel, (value) ->
      element.slider "setValue", value * 100
]