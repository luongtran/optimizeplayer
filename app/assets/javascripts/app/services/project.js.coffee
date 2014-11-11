angular.module('optimizePlayer').factory 'Project', ['$resource', ($resource) ->
  res = $resource '/api/v1/projects/:id', id: '@id',
    update:
      method: 'PUT'
    setPosition:
      method: 'PUT'
      url:    '/api/v1/projects/:id/set_position'
    toggleFavorite:
      method: 'PUT'
      url:    '/api/v1/projects/:id/toggle_favorite'
    move:
      method: 'PUT'
      url:    '/api/v1/projects/move'

  res.prototype.embedCode = ->
    "<iframe frameborder=\"0\" width=\"#{@getWidth()}\" height=\"#{@getHeight()}\" scrolling=\"no\" src=\"#{window.location.origin}/projects/#{@cid}\"></iframe>"

  res.prototype.getWidth = ->
    if @dimensions == 'custom'
      width = @custom_width
    else if @dimensions == 'responsive'
      width = @max_width
    else
      width = @dimensions.split("x")[0]
    width

  res.prototype.getHeight = ->
    if @dimensions == 'custom'
      height = @custom_height
    else if @dimensions == 'responsive'
      height = @max_height
    else
      height = @dimensions.split("x")[1]
    height

  res
]
