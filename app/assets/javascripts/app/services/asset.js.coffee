angular.module("optimizePlayer").factory "Asset", ["$resource", "$q", ($resource, $q) ->
  resource = $resource "/api/v1/assets/:id", id: "@id"
  return resource
]
