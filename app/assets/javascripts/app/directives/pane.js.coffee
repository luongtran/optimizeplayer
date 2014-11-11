angular.module("optimizePlayer").directive "pane", ->
  require: "^tabs"
  restrict: "E"
  transclude: true
  scope:
    title: "@"

  link: (scope, element, attrs, tabsCtrl) ->
    tabsCtrl.addPane scope

  template: "<div class=\"tab-pane\" ng-class=\"{active:selected}\" ng-transclude></div>"
  replace: true
