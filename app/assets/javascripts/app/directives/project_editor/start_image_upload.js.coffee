angular.module("optimizePlayer").directive "startImageUpload", [ ->
  restrict: "A"
  scope: true
  require: 'ngModel'
  link: ($scope, $element, $attrs, ctrl) ->

    $scope.removeFile = ->
      $scope.setModified()
      $scope.$parent.project.start_image = null
      return true

    $scope.onDone = (url) ->
      $scope.setModified()
      $scope.$parent.project.start_image = url
      return true

]