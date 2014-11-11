angular.module('optimizePlayer').directive 'tagLibrary', ->
  (scope, element, attrs) ->
    scope.$watch "project", ->
      if !scope.tags || scope.tags.length == 0
        scope.tags = element.find(".tags input.tagsManager").tagsManager({
          prefilled: attrs.prefilled, 
          tagsContainer: ".tags+.tags-library .list-tags",
          tagClass: "myTag",
        });
      if !scope.urls || scope.urls.length == 0
        scope.urls = element.find(".urls input.tagsManager").tagsManager({
          prefilled: attrs.prefilled, 
          tagsContainer: ".urls+.tags-library .list-tags",
          tagClass: "myTag",
        });
      
      element.on "click", ".tags a.pushTag", ->
        tag = $(this).closest('.tags').find('input.tagsManager').val()
        scope.tags.tagsManager('pushTag', tag)
      element.on "click", ".urls a.pushTag", ->
        tag = $(this).closest('.urls').find('input.tagsManager').val()
        scope.urls.tagsManager('pushTag', tag)