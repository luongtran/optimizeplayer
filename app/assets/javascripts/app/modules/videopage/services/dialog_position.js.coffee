'use_strict'

angular.module('optimizePlayer')
  .factory "dialogPosition", [ ->

    obj =
      position:
        top: null
        left: null

      set: (offsetData) ->
        @position.top = offsetData.top
        @position.left = offsetData.left

      get: ->
        @position
  ]