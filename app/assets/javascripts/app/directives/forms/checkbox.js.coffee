# <span checkbox ng-model="obj.field" label="My field"></span>
angular.module('optimizePlayer').directive 'checkbox', ['$timeout', ($timeout) ->
  restrict: 'A',
  scope: {
    value: "=ngModel",
    disabled: "=ngDisabled",
    onChange: "&onChange",
    init: "@initValue"
  },
  template: '<div class="checkbox clearfix prettycheckbox labelright blue {{class}}" ng-class="{disabled: disabled}" ng-click="check()">' +
              '<a></a>' +
              '<label ng-show="label">{{label}}</label>' +
            '</div>'
  link: (scope, element, attr, ctrl) ->
    scope.label = attr.label
    scope.class = attr.class

    scope.check = ->
      if scope.onChange
        scope.onChange()
      return if attr.ngModel == undefined
      if !scope.disabled 
        scope.value = (scope.value == undefined || scope.value.toString() == 'false')

    scope.$watch 'init', (val) ->
      element[0].querySelector("a").classList.toggle("checked", JSON.parse(val)) if val != undefined

    scope.$watch 'value', ->
      if attr.ngModel != undefined
        element[0].querySelector("a").classList.toggle("checked", scope.value && JSON.parse(scope.value))
]
