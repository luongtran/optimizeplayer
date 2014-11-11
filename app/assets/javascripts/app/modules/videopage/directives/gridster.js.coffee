angular.module("videopage").directive 'gridster', ()->
  restrict: "E"
  template: '<div class="gridster"><div ng-transclude/></div>'
  transclude: true
  replace: true
  controller: 'gridsterController'
  link: (scope, elem, attrs, controller) ->
    scope.$on 'repeatDone', (e, data) ->
      unless scope.grInit
        setTimeout ->
          controller.init elem
          #flag for define Gridster already init
          scope.grInit = true
        , 0
      else
        controller.addItem data
      # setTimeout ->
      #   controller.updateHeight()
      # , 100
      scope.setLoading(false)