preview =
  gr: null
  col_w: 60
  col_y: 35
  widgets: null
  init: ->
    @widgets = $ '.widget-wrapper'
    # @_generate_css()
    # @antiGridster()
    @gridsterInit()

    @gridsterUpdateHeight()

    # setTimeout ->
    #   FB.XFBML.parse()
    # , 100

  #I don't want to use gridster here but i had to, coz very hard to display elements on the page in the right place
  gridsterInit: ->
    @gr = $(".gridster ul").gridster(
      widget_margins: [10, 10]
      widget_base_dimensions: [60, 35]
      max_size_x: 12
      resize: {
        enabled: true
      }
      serialize_params: ($w, wgd) ->
        col: wgd.col
        row: wgd.row
        size_x: wgd.size_x
        size_y: wgd.size_y


      draggable:
        stop: (event, ui) ->
          setLayoutBackgroundHeight()
    ).data "gridster"

  gridsterUpdateHeight: ->
    self = @

    #here will watch for dynamic content
    if ($('.fb-comments').length > 0)
      setInterval ->
        fbcontent = $('.fb-comments')
        gridsterElement = fbcontent.parents('li')
        new_height = Math.round(fbcontent.height()/self.col_y)
        if parseInt(gridsterElement.attr('data-sizey')) != new_height
          self.gr.resize_widget gridsterElement, 12, new_height
      , 1000


$ ->
  preview.init()