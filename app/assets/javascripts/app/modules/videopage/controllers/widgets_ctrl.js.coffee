'use_strict'

angular.module('optimizePlayer')
  .controller('widgetsCtrl', [ '$scope', '$modalInstance','videoPageData', 'data', ($scope, $modalInstance, videoPageData, data) ->

    $scope.data = videoPageData.getWidget(data.id, data.widgetName)

    $scope.save = =>
      if _validateData $scope.data
        videoPageData.saveWidget $scope.data
        $modalInstance.close $scope.data

    $scope.cancel = ->
      $modalInstance.dismiss 'cancel'

    _validateData = (data) ->
      if data and data.validation
        for key, validation_rules of data.validation
          # console.log "key is: ", key
          for rule in validation_rules
            # console.log "val is: ", rule
            if rule is "required"
              unless data[key]
                alert "Enter required field(s)"
                return no
      yes

  ])