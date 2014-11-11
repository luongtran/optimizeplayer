angular.module('opFilters').filter "unsafe", ["$sce", ($sce) ->
  (val) ->
    $sce.trustAsHtml val
]
