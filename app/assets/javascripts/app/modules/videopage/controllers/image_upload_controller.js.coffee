angular.module("videopage").controller "ImageUploadCtrl", ["$scope", "$timeout", "$http", "$log", "Asset", "videoPageData", ($scope, $timeout, $http, $log, Asset, videoPageData) ->

  $scope.percentage = "0%"
  $scope.uploadData = null
  $scope.statusNotice = ""
  $scope.processingStarted = false
  $scope.supportedImageTypes = ["image/jpeg", "image/gif", "image/png", "image/bmp"]
  $scope.correctExtensions = ["jpg", "jpeg", "jpe", "gif", "png", "bmp"]


  # watchers #########
  $scope.$watch "data.file_origin", (val) ->
    $scope.statusNotice = ""
    $scope.resetAsset()

  $scope.$watch "data.original_filename", ->
    type = $scope.data.content_type

    # get file's extension
    extension_data = /\.([0-9a-z]+)$/i.exec($scope.data.original_filename)
    extension = extension_data[1].toLowerCase()  if extension_data

    # check extension (is it image file?) with existense checking
    if $scope.data.original_filename
      if ($scope.data.original_filename.length > 0) and (not extension or $scope.correctExtensions.indexOf(extension) < 0)
        $scope.resetAsset()
        alert "Not an image file"
      # check for web ready format
      else if (type and $scope.supportedImageTypes.indexOf(type) < 0) or not type # not web ready
        $scope.data.needs_encoding = true
      else # web ready
        $scope.data.needs_encoding = false

  # methods #########

  # callbacks for direct upload
  $scope.onFileAdd = (value) ->
    $scope.uploadData = value
    if value
      $scope.data.original_filename = value.files[0].name
      $scope.data.content_type = value.files[0].type
      $scope.statusNotice = "Ready"
      setTimeout ->
        startUpload()
      ,0

  $scope.onProgressChange = (value) ->
    $scope.percentage = value + '%'

  $scope.onDone = (remote_url, button) ->
    unless button
      $scope.data.image_url = remote_url
    else
      customButton =
        name: new Date().getTime()
        button_url: remote_url
      videoPageData.setCustomButtons customButton

      $scope.resetAsset()

      #i know this is bad practice but we have not enough time will need to redo in the future
      setTimeout ->
        $("#select_btns a").click()
        $('.fileWrapper .fileInputText').val("")
      , 0

  startUpload = ->
    if $scope.uploadData
      $scope.statusNotice = "Uploading"
      $scope.uploadData.submit()

  $scope.resetAsset = ->
    origin = $scope.data.file_origin
    $scope.data.original_filename = false
    $scope.data.content_type = false
    $scope.data.needs_encoding = false
    $scope.data.csn_id = null
    $scope.data.remote_url = false
    $scope.uploadData = null


  # var mark  boolean
  $scope.markAsButton = ( mark )->
    @isButtom = mark
]
