'use_strict'

angular.module('videopage')
  .value 'defaultData',
    videoBox:
      id: Math.floor(new Date().getTime()/Math.floor((Math.random()*100)+1))
      component: 'videoBox'
      class: 'video not-draggable not-resizable'
      dataCol: 1
      dataRow: 1
      dataSizex: 12
      dataSizey: 8
      validation: no

    title:
      id: new Date().getTime()
      title: ''
      class: "widget-title widget-content-null"
      font: "Arial"
      fontStyle: "normal"
      fontSize: '18'
      textColor: ''
      backgroundColor: ''
      component: 'title'
      dataCol: null
      dataRow: null
      dataSizex: 12
      dataSizey: 2
      validation:
        title: ["required"]

    paragraph:
      id: new Date().getTime()
      text: ""
      class: "widget-paragraph"
      font: "Arial"
      fontStyle: "normal"
      fontSize: '12'
      textColor: ''
      backgroundColor: ''
      component: 'paragraph'
      dataCol: null
      dataRow: null
      dataSizex: 6
      dataSizey: 4
      validation:
        text: ["required"]

    fbcomments:
      id: new Date().getTime()
      url: window.location.href #TODO need to change on real link
      class: "widget-fbcomments"
      type: "face-comment"
      component: 'fbcomments'
      dataCol: null
      dataRow: null
      dataSizex: 12
      dataSizey: 6
      validation: no

    fblike:
      id: new Date().getTime()
      url: window.location.href #TODO need to change on real link
      class: "widget-fblike"
      type: "face-like"
      component: 'fblike'
      dataCol: null
      dataRow: null
      dataSizex: 6
      dataSizey: 1
      validation: no

    image:
      id: Math.floor(new Date().getTime()/Math.floor((Math.random()*100)+1))
      class: "widget-image"
      component: "image"
      file_origin: ""
      original_filename: ""
      image_url: ""
      alt: ""
      dataCol: null
      dataRow: null
      dataSizex: 6
      dataSizey: 4
      validation: no

    button:
      id: Math.floor(new Date().getTime()/Math.floor((Math.random()*100)+1))
      class: "widget-buttons"
      component: "button"
      name: ""
      button_url: ""
      dataCol: null
      dataRow: null
      dataSizex: 6
      dataSizey: 4
      validation:
        button_url: ["required"]

    html:
      id: Math.floor(new Date().getTime()/Math.floor((Math.random()*100)+1))
      class: "widget-html"
      component: "html"
      name: "" # ?
      customHtml: ""
      dataCol: null
      dataRow: null
      dataSizex: 6
      dataSizey: 4
      validation:
        customHtml: ["required"]

    seodata:
      keywords: []
      title: ""
      description: ""
      validation:
        title: ["required"]

    twitter:
      id: new Date().getTime()
      url: window.location.href #TODO need to change on real link
      class: "widget-twitter"
      component: 'twitter'
      dataCol: null
      dataRow: null
      dataSizex: 6
      dataSizey: 4
      validation: no

    disqus:
      id: new Date().getTime()
      url: window.location.href #TODO need to change on real link
      class: "widget-disqus"
      type: "face-comment"
      disqus_shortname: ''
      component: 'disqus'
      dataCol: null
      dataRow: null
      dataSizex: 12
      dataSizey: 6
      validation:
        title: ["disqus_shortname"]

  .constant "BUTTONS",[
      name: "button-1"
      button_url: "/assets/widget-button-1.png"
    ,
      name: "button-2"
      button_url: "/assets/widget-button-2.png"
    ]


  .constant("LAYOUTS",
    'layout-1' :
      class: 'layout-1'
      factor: 0
      bgheight: 0
    'layout-2' :
      class: 'layout-2'
      factor: 1
      bgheight: 0
    'layout-3' :
      class: 'layout-3'
      factor: 1
      bgheight: 0
    'layout-4' :
      class: 'layout-4'
      factor: 0
      bgheight: 0
    'layout-5' :
      class: 'layout-5'
      factor: 1
      bgheight: 0
    'layout-6' :
      class: 'layout-6'
      factor: 1
      bgheight: 0
  )

  .factory "videoPageData", [
    '$q',
    '$rootScope',
    'defaultData',
    '$http',
    'Project',
    'LAYOUTS',
    'BUTTONS',
    ($q, $rootScope, defaultData, $http, Project, LAYOUTS, BUTTONS) ->

      data =
        project: null
        videopage: null
        gridsterInstanse: null

        init: (project)->
          unless @project and project
            @project = project
            @getVideoPage()

        updateWidgetsOrdering: (widgets) ->
          self = @
          _(widgets).forEach (widget)->
            if widget.id
              cur_widget = self.__getWidgetById widget.id
              if cur_widget
                angular.extend cur_widget, widget
          @__reOrderingWidgets()


        # i added this method in order to display widgets on preview in right ordering without gridster
        # becuse gridster has position: absolute for each block and it is not quite good, and content
        # can not to be autogrow
        __reOrderingWidgets: ->
          self = @
          temp_widgets = []
          array_ordered_widgets = _.map(_.sortBy(@videopage.widgets, ['dataRow', 'dataCol']), _.values)
          _(array_ordered_widgets).each (element)->
            object = _.findIndex self.videopage.widgets, id: element[0]
            if object != -1
              temp_widgets.push self.videopage.widgets[object]

          angular.extend @videopage.widgets, temp_widgets
          self.savePage()
          return

        getAllWidgets: ->
          @videopage.widgets

        __addDefaultWidgets: ->
          # defaultTitle = angular.copy defaultData.title
          # defaultTitle.title = "This is my first video page"
          # defaultTitle.dataCol = 1
          # defaultTitle.dataRow = 1
          # @videopage.widgets.push defaultTitle
          @videopage.widgets.push defaultData.videoBox

        getWidget: (id, widgetName) ->
          if !id || !@__getWidgetById id
            instance = angular.copy defaultData[widgetName]
            instance.id = new Date().getTime()
            instance
          else
            #return clone in order to have opportunity for cancel changes
            angular.copy @__getWidgetById id

        saveWidget: (widget) ->
          current_widget = @__getWidgetById widget.id
          widget.dataSizex = parseInt widget.dataSizex
          widget.dataSizey = parseInt widget.dataSizey

          unless current_widget
            position = @gridsterInstanse.next_position(widget.dataSizex, widget.dataSizey)
            widget.dataCol = position.col
            widget.dataRow = position.row
            @videopage.widgets.push widget
          else
            angular.extend current_widget, widget
            $rootScope.$emit 'editWidget', widget: current_widget

        addGridster:(gr_instanse) ->
          @gridsterInstanse = gr_instanse

        removeWidget: (id) ->
          index = _.findIndex @videopage.widgets, id: id
          @videopage.widgets.splice(index,1);
          #fire event
          $rootScope.$emit 'removeWidget', id: id

        getVideoPage: ()->
          self = @
          $http(
            method: 'GET',
            url: "/api/v1/videopages/#{self.project.id}/page"
          ).then (respond)->
            self.videopage = respond.data
            self.videopage.widgets = $.trim self.videopage.widgets
            if self.videopage.widgets and self.videopage.widgets.length
              self.videopage.widgets = angular.fromJson self.videopage.widgets
            else
              self.videopage.widgets = null

            if self.videopage.template
              self.videopage.template = self.videopage.template
            else
              self.videopage.template = null

            if self.videopage.slug
              self.videopage.slug = { slug: self.videopage.slug }
            else
              self.videopage.slug = null

            unless self.videopage.settings
              self.videopage.settings =
                backgroundColor: '#F0F8FF'

            if self.videopage.seo and self.videopage.seo.length
              self.videopage.seo = angular.fromJson self.videopage.seo
              unless self.videopage.seo.keywords
                self.videopage.seo.keywords = []
            else
              self.videopage.seo = angular.copy defaultData['seodata']

            self.videopage.custom_buttons = angular.copy BUTTONS

            unless self.videopage.widgets
              self.videopage.widgets = []
              self.__addDefaultWidgets()

        getSettings: ->
          if @videopage.settings? and @videopage.settings != ""
            @videopage.settings
          else
            @videopage.settings =
              backgroundColor: '#F0F8FF'

        savePage: ()->
          self = @
          $http(
            method: 'PUT',
            url: "/api/v1/videopages/#{self.project.id}/save",
            data:
              data: self.videopage
          ).then (respond)->

        saveSlug: (slug)->
          self = @
          @videopage.slug = slug
          $http(
            method: 'PUT',
            url: "/api/v1/videopages/#{self.project.id}/slug_save",
            data:
              slug: slug
          ).then (respond)->

        #should use as private method
        __getWidgetById: (id) ->
          index = _.findIndex @videopage.widgets, id: id
          if index != -1
            @videopage.widgets[index]
          else
            false

        setTemplate: (template)->
          @videopage.template = LAYOUTS[template]
          #counting
          @calculateBgHeight()

          @videopage.template

        calculateBgHeight: ->
          top_g = angular.element(".gridster").offset().top
          top_v = angular.element(".gridster li.video").offset().top
          height_v = angular.element(".gridster li.video").height()
          if @videopage.template.factor > 0
            @videopage.template.bgheight = top_v - top_g + (height_v / @videopage.template.factor)
            angular.element(".widgets-layout-bg").css "height", @videopage.template.bgheight + "px"

          @videopage.template

        getTemplate: ()->
          res = @videopage.template

          if angular.equals({},res)
            @videopage.template = LAYOUTS['layout-1']
          @videopage.template

        getSeo: ()->
          res = @videopage.seo
          unless res?
            @videopage.seo = angular.copy defaultData['seodata']
          @videopage.seo

        setSeo: (seodata)->
          @videopage.seo = seodata

        getCustomButtons: ()->
          res = @videopage.custom_buttons
          unless res?
            @videopage.custom_buttons = angular.copy BUTTONS
          @videopage.custom_buttons

        setCustomButtons: (button)->
          @videopage.custom_buttons.push button

        getSlug: ()->
          res = @videopage.slug
          unless res?
            @videopage.slug = angular.extend
              slug: ''

          @videopage.slug


  ]