angular.module("optimizePlayer").controller "AssetUploadCtrl", ["$scope", "$element", "$timeout", "$http", "$log", ($scope, $element, $timeout, $http) ->
  # init #########

  $scope.statusNotice = ""
  $scope.processingStarted = false
  $scope.supportedVideoTypes = ["video/mp4", "video/ogg", "video/webm", "application/mp4", "video/x-flv", "video/vnd.objectvideo", "video/x-m4v"]
  $scope.correctExtensions = ["3gp", "3gpp", "3g2", "3gpp2", "dl", "gl", "mj2", "mjp2", "ts", "f4p", "f4v", "mp4", "mpg4", "mp2", "mp3g", "mpe", "mpeg", "mpg", "ogg", "ogv", "mov", "qt", "m4u", "mxu", "nim", "m4v", "mp4", "s11", "s14", "smpg", "ssw", "sswf", "s1q", "smo", "smov", "viv", "vivo", "webm", "dl", "dv", "fli", "flv", "gl", "ivf", "mkv", "mjpeg", "mjpg", "asf", "asx", "wm", "wmv", "wmx", "wvx", "avi", "movie"]
  $scope.processingFailed = false

  # watchers #########
  $scope.$watch "asset.file_origin", (val) ->
    $scope.statusNotice = ""
    $scope.resetAsset()

  $scope.$watch "asset.original_filename", ->
    type = $scope.asset.content_type

    # get file's extension
    extension_data = /\.([0-9a-z]+)$/i.exec($scope.asset.original_filename)
    extension = extension_data[1].toLowerCase()  if extension_data

    # check extension (is it video file?) with existense checking
    if $scope.asset.original_filename
      $scope.project.title = $scope.asset.original_filename
      if ($scope.asset.original_filename.length > 0) and (not extension or $scope.correctExtensions.indexOf(extension) < 0)
        $scope.resetAsset()
        alert "Not a video file"
      # check for web ready format
      else if (type and $scope.supportedVideoTypes.indexOf(type) < 0) or not type # not web ready
        $scope.asset.needs_encoding = true
      else # web ready
        $scope.asset.needs_encoding = false
        $scope.asset.keep_video_size = false

  $scope.$watch "opts.csnForUpload", (value) ->
    if $scope.asset && $scope.asset.file_origin == "connect"
      $scope.asset.csn_id = value.id

  # methods #########

  # callbacks for direct upload
  $scope.onFileAdd = (value) ->
    $scope.uploadData = value
    if value
      $scope.asset.original_filename = value.files[0].name
      $scope.asset.content_type = value.files[0].type
      $scope.statusNotice = "Ready"
      $scope.processingStarted = false
      $scope.processingFailed = false

  $scope.onProgressChange = (value) ->
    $scope.percentage = value + '%'

  $scope.onDone = (remote_url, isNewProject) ->
    $scope.percentage = '0%'
    if isNewProject
      $scope.asset.download_url = remote_url
      $scope.asset.csn_id = $scope.opts.csnForUpload.id
      $scope.asset.$save ->
        $scope.updateProject()
        $scope.createProject()

  $scope.toUpdatingProject = ->
    $scope.asset.csn_id = $scope.opts.csnForUpload.id
    $scope.asset.$save ->
      $scope.updateProject()
      $scope.createProject()

  $scope.onFail = (messages) ->
    $scope.processingFailed = true
    $scope.statusNotice = "Error"

  $scope.browseFiles = ->
    $('.csn-upload-file').click()
    return true

  $scope.browseUserFiles = ->
    $('#dropzone').find('.csn-upload-file').click()
    return true

  $scope.processAsset = -> # entry point
    if $scope.asset.needs_encoding and not ($("input[name=\"asset[needs_encoding]\"]").is(":checked"))
        alert "You must encode your video file or please select another web ready file format"
    else # all is good
      $scope.processingStarted = true
      if $scope.asset.file_origin == 'connect' # chosen from CSN
        if $scope.asset.needs_encoding
          startEncoding()
        else
          $scope.asset.$save ->
            $scope.updateProject()
      else # uploading from computer
        startUploading()

  $scope.resetAsset = ->
    origin = $scope.asset.file_origin
    $scope.asset.original_filename = false
    $scope.asset.content_type = false
    $scope.asset.needs_encoding = false
    $scope.asset.csn_id = null
    $scope.asset.remote_url = false
    $scope.uploadData = null

  # some methodts for ng-show/hide conditions
  $scope.cloudfrontCheckbox = ->
    not ($scope.asset.needs_encoding) and $scope.asset.csn_id and      # csn file in web format
      $scope.awsCsnIds.find($scope.asset.csn_id) and                   # and csn with enabled cloudfront option
      not ($scope.processingStarted) and                               # and wizard at initial state
      $scope.asset.key.search( $scope.csns.find(id: $scope.asset.csn_id).bucket ) != 0 # and bucket isn't "cloudfronted"
]
