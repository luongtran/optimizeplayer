'use_strict'

angular.module('optimizePlayer')

  .controller("dialogCtrl", ["$scope", "videoPageData", 'dialog', ($scope, videoPageData, dialog) ->

    $scope.editWidget = (widgetName, id = null) ->
      #TODO check if widget is not exist
      dialog.type = widgetName
      dialog.title = "Widget Options"
      dialog.open(
        templateUrl: "/assets/widget_popover_#{widgetName}.html",
        controller: 'widgetsCtrl'
        data:
          id: id
          widgetName: widgetName
      ).then( (data) ->
          console.log "Done"
        )

    $scope.addWidget = (widgetName, id = null)->
      $scope.data = videoPageData.getWidget(id, widgetName)
      videoPageData.saveWidget $scope.data

    $scope.seoForm = ->
      dialog.type = "seo"
      dialog.title = "SEO Options"
      dialog.open(
        templateUrl: "/assets/popover_seo.html",
        controller: 'seoCtrl'
        data: videoPageData.getSeo()
      ).then( (data) ->
          console.log "Done"
        )
  ])