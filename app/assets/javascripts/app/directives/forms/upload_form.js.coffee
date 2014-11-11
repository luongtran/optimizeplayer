angular.module("optimizePlayer").directive "uploadForm", ['$rootScope', ($rootScope) ->
  link: ($scope, $element, $attrs, ctrl) ->

    $scope.percentage = "0%"
    $scope.uploadData = null
    $scope.uploadResult = null
    $scope.btnText = "Upload"

    $scope.$watch "uploadData", (value) ->
      $scope.original_filename = value.files[0].name if value

    $scope.$watch "uploadResult", (value) ->
      if value
        $scope.updateFile value
        $scope.btnText = "Done!"

    $scope.browseFiles = ->
      $element.find("input:hidden[name=\"file\"]").trigger "click"
      return true
]