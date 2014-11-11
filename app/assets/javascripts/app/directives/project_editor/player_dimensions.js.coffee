"use strict"
angular.module("optimizePlayer").directive "playerDimensions", ->
  link: ($scope, $element) ->
    console.log 'ussse'
    $scope.custom_width = 720
    $scope.custom_height = 405
    $scope.isCustom = false
    if ($scope.project.dimensions && ["640x360", "720x405", "960x540", "responsive"].indexOf($scope.project.dimensions) < 0)
      $scope.custom_width = $scope.project.dimensions.split("x")[0]
      $scope.custom_height = $scope.project.dimensions.split("x")[1]
      $scope.isCustom = true
    $element.on "change", "[name=dimension]", ->
      $scope.isModified = true 
      
      $this = $(this)
      if $this.val() is "custom"
        $scope.$apply ->
          $scope.set_custom_dimensions()
          $scope.isCustom = true

      else
        $scope.isCustom = false
        $scope.$apply ->
          $scope.project.dimensions = $this.val()

    $scope.$watch "[custom_height, custom_width]", ((value) ->
      $scope.set_custom_dimensions()  if $scope.isCustom
    ), true
    
    $scope.set_custom_dimensions = ->
      $scope.project.dimensions = $scope.custom_width + "x" + $scope.custom_height
