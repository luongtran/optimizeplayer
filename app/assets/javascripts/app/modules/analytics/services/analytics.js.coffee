angular.module("analytics").factory "Analytics", ['$q', '$rootScope', ($q, $rootScope) ->
  viewers: [],
  hours_watched: 0,
  pullEvents: (project_cid, filters = []) ->
    that = this
    that.pullMetric(project_cid, {
      analysisType: "extraction",
      filters: filters
    })
  pullViewers: (project_cid) ->
    that = this
    that.pullMetric(project_cid, {
      analysisType: "select_unique", 
      targetProperty: "session"
    }).then (result) ->
      that.viewers = result
  pullMetric: (cid, options) ->
    deferred = $q.defer()
    new Keen.Metric(cid, options)
    .getResponse (response) ->
      $rootScope.$apply ->
        deferred.resolve(response.result)
    return deferred.promise
]

