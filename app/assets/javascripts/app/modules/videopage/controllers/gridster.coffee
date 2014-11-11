'use_strict';

angular.module("videopage")
  .controller('gridsterController', [ '$rootScope', '$scope', 'videoPageData', ($rootScope, $scope, videoPageData) ->
    gr = null
    $scope.grInit = false

    $scope.removeWidget = (id)->
      videoPageData.removeWidget id

    $rootScope.$on 'removeWidget', (e, data) ->
      gr.remove_widget angular.element("#id_#{data.id}"), false, ->
        videoPageData.updateWidgetsOrdering gr.serialize()
        videoPageData.calculateBgHeight()

    $rootScope.$on 'nowidgets', (e, data)->
      grController.init data.data
      $scope.grInit = true

    $rootScope.$on 'editWidget', (e, data) ->
      gr.resize_widget angular.element("#id_#{data.widget.id}"), data.widget.dataSizex, data.widget.dataSizey
      videoPageData.updateWidgetsOrdering gr.serialize()
      # setTimeout ->
      #   grController.updateHeight()
      #   gr.set_dom_grid_height()
      # , 100
      # videoPageData.calculateBgHeight()

    grController = {
      init: (elem) ->
        self = @
        ul = elem.find("ul")
        gr = ul.gridster({
          widget_margins: [10, 10]
          widget_base_dimensions: [60, 35]
          max_size_x: 12
          serialize_params: (w, wgd)->
            id: parseInt wgd.el[0].id.replace /id_/g, ''
            dataCol: wgd.col
            dataRow: wgd.row
            dataSizey: wgd.size_y
            dataSizex: wgd.size_x
          resize:
            items: '.gs_w:not(.not-resizable)'
            enabled: true
            min_size: [4, 2]
            max_size: [12, 20]
            stop: (e, ui, wgd) ->
              newHeight = @resize_coords.data.height
              newWidth = @resize_coords.data.width
              videoPageData.updateWidgetsOrdering gr.serialize()
          draggable:
            items: '.gs_w:not(.not-draggable)'
            stop: (event, ui) ->
              videoPageData.updateWidgetsOrdering gr.serialize()
              videoPageData.calculateBgHeight()
              gr.set_dom_grid_height()
        }).data('gridster')

        #i added gridster instanse to service becuase i need to change positions
        videoPageData.addGridster gr
        return

      #gridster make absolute height, but sometime content more then height and need to try to fit it
      updateHeight: ->
        widgets = gr.$widgets
        row_height = 45
        widgets.each ->
          widget = angular.element(@)
          dataSizex = parseInt(widget.attr('data-sizex'))
          content = widget.find('.ng-scope:not(#video-preview)')
          wrapper= content.find('.wg-content-wrapper')
          if widget.hasClass('widget-image') or widget.hasClass('widget-buttons')
            image = wrapper.find 'img'
            image.bind 'load', ->
              height = wrapper.height()
              if height
                new_height = Math.round(height/row_height)+1
                # console.log "***HEIGHT***", height
                # console.log "I have #{widget.attr('data-sizey')}, but i need #{new_height}"
                gr.resize_widget widget, dataSizex, new_height
                # videoPageData.updateWidgetsOrdering gr.serialize()
                gr.set_dom_grid_height()
          else
            height = wrapper.height()
            if height
              new_height = Math.round(height/row_height)+1
              # console.log "***HEIGHT***", height
              # console.log "I have #{widget.attr('data-sizey')}, but i need #{new_height}"
              gr.resize_widget widget, dataSizex, new_height
              # videoPageData.updateWidgetsOrdering gr.serialize()
              gr.set_dom_grid_height()


      addItem: (data) ->
        console.log "Adding widget....", data
        # position = gr.next_position(data.attrs.sizex, data.attrs.sizey)
        gr.add_widget data.element, data.attrs.sizex, data.attrs.sizey
        # videoPageData.updateWidgetsOrdering gr.serialize()
    }
  ])