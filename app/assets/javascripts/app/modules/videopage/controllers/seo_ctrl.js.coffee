'use_strict'

angular.module('optimizePlayer')
  .controller('seoCtrl', [ '$scope', '$modalInstance','videoPageData', 'data', ($scope, $modalInstance, videoPageData, data) ->
    sourceData = angular.copy data
    $scope.data = data

    $scope.save = ->
      if _validateData $scope.data
        videoPageData.setSeo $scope.data
        $modalInstance.close $scope.data

    $scope.cancel = ->
      angular.extend $scope.data, sourceData
      $modalInstance.dismiss 'cancel'

    $scope.pull = (keyword) ->
      index = _.indexOf $scope.data.keywords, keyword
      $scope.data.keywords.splice index, 1

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