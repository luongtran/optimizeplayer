angular.module('optimizePlayer').filter 'foldersToOptions', ->
  memoizeInput  = ''
  memoizeResult = []

  (inputArr) ->
    unless angular.toJson(inputArr) == memoizeInput
      memoizeInput  = angular.toJson(inputArr)
      memoizeResult = inputArr.map (x) ->
        [{name: x.name, id: x.id}, x.subfolders.map (sf) ->
          {name: "- #{sf.name}", id: sf.id}
        ]
      .flatten().compact()
    memoizeResult
