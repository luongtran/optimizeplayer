'use_strict'

angular.module('optimizePlayer').factory('dialog', ['$modal','dialogPosition', ($modal, dialogPosition) ->
    dialog =
      options:
        title: ''
      open: (options) ->
        modalInstance = $modal.open
          templateUrl: options.templateUrl,
          controller: options.controller,
          keyboard: no
          resolve:
            data: ->
              options.data
        modalInstance.result
  ])