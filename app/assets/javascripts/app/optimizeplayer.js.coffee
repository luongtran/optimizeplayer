angular.module "analytics",       []
angular.module "videopage",       []
angular.module "projectsManager", []
angular.module "opFilters",       []

modules = ["analytics", "videopage", "projectsManager", "ngResource", "ngRoute", "ngSanitize",
           "angularTree", "infinite-scroll", "ui.bootstrap.modal", "ui.bootstrap.tabs",
           "angular-redactor", 'opFilters', 'minicolors', 'angular-bootstrap-select']

try
  angular.module("optimizePlayerWidget");
  modules.push("optimizePlayerWidget");


angular.module "optimizePlayer", modules
angular.module("optimizePlayer").config ["$httpProvider", ($httpProvider) ->
  $httpProvider.defaults.headers.common["X-CSRF-Token"] = $("meta[name=csrf-token]").attr("content")
]
