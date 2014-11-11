angular.module("optimizePlayer").directive "logoUpload", [ ->
  restrict: "A"
  scope: true
  require: 'ngModel'
  link: ($scope, $element, $attrs, ctrl, ngModel) ->

    $scope.file = $scope.$parent.project.logo

    $scope.removeFile = ->
      $scope.setModified()
      $scope.$parent.project.logo = null
      $scope.percentage = "0%"
      $scope.uploadData = null
      $scope.uploadResult = null
      $scope.btnText = "Upload"
      $scope.original_filename = null
      $scope.file = null

    $scope.onProgressChange = (percentage) ->
      $scope.percentage = percentage + "%"

    $scope.onDone = (url) ->
      $scope.setModified()
      $scope.$parent.project.logo = url
      $scope.file = url
      return true

    $scope.moveLogo = ->
      $("#logo-preview").show()
      $scope.$parent.logo.orig = $scope.$parent.project.logo
      $scope.$parent.project.logo = false
      $scope.$parent.cta_store.currentCta = false
      $scope.isMoving = true

    $scope.saveLogo = ->
      $("#logo-preview").hide()
      $scope.$parent.project.logo = $scope.$parent.logo.orig
      $scope.$parent.logo.orig = ''
      $scope.$parent.project.logo_pos_top = $("#logo-preview img").css("top")
      $scope.$parent.project.logo_pos_left = $("#logo-preview img").css("left")
      $scope.isMoving = false

]