# this controller contains actions that affects sortable logic
# TODO: rewrite sortable directive to contain all DOM manipulations
angular.module('projectsManager').controller 'ProjectListCtrl', ['$scope', '$timeout', '$q', 'Project', 'Folder', ($scope, $timeout, $q, Project, Folder) ->
  # init scope
  $scope.projects = []
  $scope.selectedIds = []
  $scope.tooltips = {filesId: null, tagsId: null}
  $scope.sortableOptions =
    handle:       '.draggable'
    containment:  '.folder-content'
    items:        '> ul:not(.static):visible'
    update:       (e, ui) ->
      Project.setPosition
        id:       ui.item.find('.project-id').text()
        position: ui.item.index() + 1 # because acts_as_list prefers 1 as high position

  $scope.$on 'folderChanged', ->
    $scope.selectedIds.remove -> true
    $scope.projects = []
    $scope.updateProjectsList()

  $scope.updateProjectsList = ->
    if $scope.current.data and $scope.current.data.id
      $scope.selectedIds = []
      folder_id = $scope.current.data.id
      if folder_id == 'search'
        $scope.projects = $scope.$parent.found
      else
        tmp = Project.query folder_id: folder_id, ->
          $scope.projects = tmp

  getFoldersToUpdate = (ids) ->
    folders = $scope.folders
    toRootIdsMap = {}
    folders.each (f) ->
      toRootIdsMap[f.id] = f.id
      f.subfolders.each (sf) ->
        toRootIdsMap[sf.id] = f.id

    newIds = ids.map( (id) -> toRootIdsMap[id]).unique()

    folders.filter( (f) -> newIds.some(f.id) )


  bulkDelete = (selected, def) ->
    pCount = selected.length
    $scope.projects.remove (p) ->
      selected.some(p)

    selected.each (p) ->
      p.$remove ->
        pCount--
        def.resolve() if pCount == 0

    return selected.map( (p) -> p.folder_id ).unique()

  bulkMove = (selected, def) ->
    folderId = $scope.destFolderId

    previousIds = []
    ids = []

    selected.each (p) ->
      previousIds.push p.folder_id
      p.folder_id = folderId
      ids.push p.id

    Project.move ids: ids, folder_id: folderId, ->
      def.resolve()

    toUpdateIds = previousIds
    toUpdateIds.push(parseInt folderId)
    return toUpdateIds.unique()

  bulkExport = (selected, def) ->
    ids = selected.map( (x) -> x.id )
    location.href = "/projects/export.csv?#{Object.toQueryString({ids: ids})}"

    def.resolve()
    return []

  $scope._showBulk = ->
    $scope.showBulk = !$scope.showBulk
    # avoid strange behavoir of select
    $scope.action = $('.bulk-select-action').val()
    $scope.destFolderId = $('.bulk-select-dest').val()

  $scope.bulkAction = ->
    ids = $scope.selectedIds
    def = $q.defer()
    selected = $scope.projects.filter (p) ->
      ids.any(p.id)

    toUpdateIds = if $scope.action == 'Move'
      bulkMove(selected, def)
    else if $scope.action == 'Delete'
      bulkDelete(selected, def)
    else if $scope.action == 'Export'
      bulkExport(selected, def)

    $scope.selectedIds = []
    $scope.showBulk = false
    $scope.$broadcast 'dropSelection'
    def.promise.then ->
      $scope.updateProjectsList()
      getFoldersToUpdate(toUpdateIds).each (folder) ->
        folder.$get()

  $scope.favoritesResort = (project) ->
    $scope.updateProjectsList()
]

