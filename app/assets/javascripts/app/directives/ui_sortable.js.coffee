#
# jQuery UI Sortable plugin wrapper
#
# @param [ui-sortable] {object} Options to pass to $.fn.sortable() merged onto ui.config
#
angular.module('optimizePlayer')
  
  .value("uiSortableConfig", {})
  
  .directive "uiSortable", ["uiSortableConfig", (uiSortableConfig) ->
    require: "?ngModel"
    link: (scope, element, attrs, ngModel) ->
      combineCallbacks = (first, second) ->
        if second and (typeof second is "function")
          return (e, ui) ->
            first e, ui
            second e, ui
        first
      opts = {}
      callbacks =
        receive: null
        remove: null
        start: null
        stop: null
        update: null

      apply = (e, ui) ->
        scope.$apply()  if ui.item.sortable.resort or ui.item.sortable.relocate

      angular.extend opts, uiSortableConfig
      if ngModel
        ngModel.$render = ->
          element.sortable "refresh"

        callbacks.start = (e, ui) ->
          
          # Save position of dragged item
          ui.item.sortable = index: ui.item.index()

        callbacks.update = (e, ui) ->
          
          # For some reason the reference to ngModel in stop() is wrong
          ui.item.sortable.resort = ngModel

        callbacks.receive = (e, ui) ->
          ui.item.sortable.relocate = true
          
          # added item to array into correct position and set up flag
          ngModel.$modelValue.splice ui.item.index(), 0, ui.item.sortable.moved

        callbacks.remove = (e, ui) ->
          
          # copy data into item
          if ngModel.$modelValue.length is 1
            ui.item.sortable.moved = ngModel.$modelValue.splice(0, 1)[0]
          else
            ui.item.sortable.moved = ngModel.$modelValue.splice(ui.item.sortable.index, 1)[0]

        callbacks.stop = (e, ui) ->
          
          # digest all prepared changes
          if ui.item.sortable.resort and not ui.item.sortable.relocate
            
            # Fetch saved and current position of dropped element
            end = undefined
            start = undefined
            start = ui.item.sortable.index
            end = ui.item.index()
            
            # Reorder array and apply change to scope
            ui.item.sortable.resort.$modelValue.splice end, 0, ui.item.sortable.resort.$modelValue.splice(start, 1)[0]
      scope.$watch attrs.uiSortable, ((newVal, oldVal) ->
        angular.forEach newVal, (value, key) ->
          if callbacks[key]
            
            # wrap the callback
            value = combineCallbacks(callbacks[key], value)
            
            # call apply after stop
            value = combineCallbacks(value, apply)  if key is "stop"
          element.sortable "option", key, value

      ), true
      angular.forEach callbacks, (value, key) ->
        opts[key] = combineCallbacks(value, opts[key])

      
      # call apply after stop
      opts.stop = combineCallbacks(opts.stop, apply)
      
      # Create sortable
      element.sortable opts
  ]
