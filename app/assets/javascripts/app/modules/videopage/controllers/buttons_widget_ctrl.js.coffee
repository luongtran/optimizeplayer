'use_strict'

angular.module('optimizePlayer')
  .controller('buttonsWidgetCtrl', [ '$scope','videoPageData', ($scope, videoPageData) ->
    $scope.buttons_widget = videoPageData.getCustomButtons()

    $scope.current = false
    $scope.selectButton = (name)->
      $scope.current = name
      index = _.findIndex($scope.buttons_widget, {name: name})
      if index isnt -1
        $scope.data.button_url = $scope.buttons_widget[index].button_url
        $scope.data.name = $scope.buttons_widget[index].name
  ])