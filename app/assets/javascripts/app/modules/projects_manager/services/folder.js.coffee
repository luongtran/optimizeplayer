angular.module('projectsManager').factory 'Folder', ['$resource', ($resource) ->
  $resource('/api/v1/folders/:id', id: '@id')
]
