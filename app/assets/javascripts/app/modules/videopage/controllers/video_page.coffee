"use_strict"
angular.module("videopage")

  .controller("VideoPageCtrl", ["$scope", "$rootScope", "$http", "$compile", "$window", "Project", "videoPageData", "LAYOUTS", ($scope, $rootScope, $http, $compile, $window, Project, videoPageData, LAYOUTS) ->
    $scope.widgets = []

    $scope.init = (project) ->
      $scope.setLoading true
      $scope.saveText = "Save"
      $scope.project = new Project(project)

      videoPageData.init(project).then((data) ->
        $scope.widgets = videoPageData.getAllWidgets()
        $scope.slug = videoPageData.getSlug()
        $scope.template = videoPageData.getTemplate()
        $scope.settings = videoPageData.getSettings()

        unless $scope.widgets.length > 0
          $rootScope.$emit 'nowidgets', data: $('.gridster')
          $scope.setLoading false
       , (err) ->
        console.log "error", err
      )

    $scope.savePage = (next)->
      $scope.saveText = "Saving"
      if $scope.slug.slug? and $scope.slug.slug != ""
        scope = $scope
        videoPageData.savePage().then((data)->
          console.log "Saved success!"
          scope.saveText = "Saved"
          scope.checkSaveClass = "button-submit-success"
          next(true) if next
        , (error)->
          console.log "Doesn't save something wrong"
          scope.saveText = "Not saved"
          scope.checkSaveClass = "button-submit-error"
          next(false) if next
        )
        console.log "Saving page..."
      else
        alert "url is blank"

    $scope.goToPreview = ->
      win = $window.open('about:blank')
      $scope.savePage( (saved)->
        if saved
          win.location.href = "/"+$scope.slug.slug
        else
          win.close()
          alert("Can't save")
      )

    $scope.changeLayout = (layout)->
      $scope.template = videoPageData.setTemplate(layout)

    $scope.saveSlug = ->
      # unless angular.equals({},$scope.slug) and typeof($scope.slug) != "undefined" and $scope.slug.slug != ""
      if $scope.slug.slug? and $scope.slug.slug != ""
        scope = $scope
        videoPageData.saveSlug($scope.slug).then ((data) ->
          console.log "Slug successly saved!"
          scope.checkClass = "button-success"
        ), (error) ->
          console.log "Doesn't save something wrong"
          scope.checkClass = "button-error"
        console.log "Saving slug..."
        notempty = false
      else
        alert "url is blank"

    $scope.setLoading = (loading) ->
      $scope.isLoading = loading

    $scope.layoutDone = ->
      # $scope.setLoading false
      $timeout (->
        $scope.setLoading false
      ), 0
  ])
