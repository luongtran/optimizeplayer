angular.module("optimizePlayer").directive "timeOptions", ->
  restrict: 'E'
  templateUrl: '/assets/project_editor/time_options.html'
  scope: false
  link: ($scope, $element, $attrs) ->
    $scope.type = $attrs.type
