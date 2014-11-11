angular.module("optimizePlayer").directive "csnFinder", ["$http", "$rootScope", "$timeout", "$filter", "Integration", ($http, $rootScope, $timeout, $filter, Integration) ->
  link: ($scope, $element, $attrs) ->
    @integrationService = new Integration()

    $scope.search = ""
    $scope.current_bucket = null
    $scope.inProgress = false
    $rootScope.goToNextStep = false

    addParentFields = (folderData, parent) ->
      parent ||= [folderData.name]
      folderData.parent = parent
      if folderData.subdirs
        folderData.subdirs.each (subdir) ->
          addParentFields(subdir, parent.include(subdir.name))
      folderData

    $scope.$watch "current_csn", ->
      $scope.loadAmazonBuckets()

    $scope.$watch "current_hosting_csn", ->
      $scope.loadHostingBuckets()

    $scope.loadHostingBuckets = ->
      $scope.folder_name = undefined
      $scope.current_hosting_folder = undefined
      if $scope.current_hosting_csn
        integrationService.loadOPHostingBucket().then((response) ->
          $scope.folder_name = response.data
          integrationService.loadCsnDirectories({id: $scope.current_hosting_csn.id, provider: $scope.current_hosting_csn.provider, bucket: $scope.folder_name}).then((response) ->
            if $scope.current_hosting_csn.id == parseInt(response.data.csn_id)
              $scope.current_hosting_csn.buckets = response.data.directories
              userDirectory = $filter('filter')($scope.current_hosting_csn.buckets.subdirs, response.data.folder)
              if userDirectory
                encodingsFolder = $filter('filter')(userDirectory[0].subdirs, 'encodings')
                $scope.current_hosting_folder = encodingsFolder[0]
                $scope.current_hosting_bucket = $scope.current_hosting_folder.name if $scope.current_hosting_folder
          )
        )

    $scope.loadAmazonBuckets = ->
      $scope.current_folder = undefined
      if $scope.current_csn
        integrationService.loadCsnDirectories({id: $scope.current_csn.id, provider: $scope.current_csn.provider}).then((response) ->
              if $scope.current_csn.id == parseInt(response.data.csn_id)
                $scope.current_csn.buckets = response.data.directories
            )

    $rootScope.$watch "isLoadingFile", ->
      if $rootScope.isLoadingFile == false
        $scope.loadAmazonBuckets()

    $element.on "click", ".main-csn li a.folder", ->
      if $(this).siblings("ul").find("li").length > 0
        $this = $(this)
        $this.siblings("ul").stop().slideToggle 250
      false

    $scope.selectFile = ->
      if $scope.asset.needs_encoding
        $modal = $('#upload-new-video')
        $modal.css("margin-top", "-" + ($modal.height() / 2) + "px")
        $modal.foundation('reveal', 'open')
      else
        $scope.inProgress = true
        $scope.asset.$save (data) ->
          $scope.asset.remote_url = data.remote_url
          $scope.updateProject()
          $scope.createProject()
      return

    $scope.isHighlighted = (item) ->
      return false unless $scope.current_folder and $scope.current_folder.parent
      return false unless item and item.parent
      currentPath = $scope.current_folder.parent.toString()
      itemPath    = item.parent.toString()
      currentPath.startsWith(itemPath)

    $scope.setCurrentFolder = (folder, isBucket = false) ->
      $scope.current_folder = folder
      if isBucket && !$scope.current_folder.loaded
        $scope.current_folder.isBucket = true
        $scope.current_bucket = folder.name
        integrationService.loadCsnDirectories({id: $scope.current_csn.id, provider: $scope.current_csn.provider, bucket: folder.name}).then((response) ->
          if $scope.current_csn.id == parseInt(response.data.csn_id)
            addParentFields(angular.extend($scope.current_folder, response.data.directories))
            $scope.current_folder.loaded = true
        )

    $scope.extendAsset = (file) ->
      $.extend $scope.asset,
        key: file.key
        original_filename: file.name
        content_type: file.content_type
        download_url: file.download_url
        remote_url: file.url
        # file_origin: 'connect'

    $scope.setHostingConnectedFile = (file) ->
      $scope.asset.csn_id = $scope.current_hosting_csn.id
      $scope.asset.original_bucket = $scope.current_hosting_bucket
      $scope.extendAsset(file)
      if $scope.asset.remote_url
        $rootScope.goToNextStep = true
      $rootScope.showProgress = $scope.asset.needs_encoding

    $scope.setConnectedFile = (file) ->
      $scope.asset.csn_id = $scope.current_csn.id
      $scope.asset.original_bucket = $scope.current_bucket
      $scope.extendAsset(file)
      if $scope.asset.remote_url
        $rootScope.goToNextStep = true
      $rootScope.showProgress = $scope.asset.needs_encoding

    $scope.deleteFile = (file, index) ->
      @integration = new Integration()
      @integration.deleteFile({bucket: file.bucket, file_key: file.file_key}).then((response) ->
          if response.status == 200
            $scope.current_hosting_folder.files.splice(index, 1);
        )
]
