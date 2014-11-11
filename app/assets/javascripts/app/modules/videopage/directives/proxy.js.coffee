#this Direcive replace elements in ng-repeat on their real view
angular.module("videopage").directive("proxy", ['$parse', '$injector', '$compile', '$http', ($parse, $injector, $compile, $http) ->
  replace: true
  link: (scope, element, attrs) ->
    a = undefined
    directive = undefined
    name = undefined
    nameGetter = undefined
    value = undefined
    valueGetter = undefined
    nameGetter = $parse(attrs.proxy)
    name = nameGetter(scope)
    value = `undefined`
    if attrs.proxyValue
      valueGetter = $parse(attrs.proxyValue)
      value = valueGetter(scope)
    directive = $injector.get('wg' + name.component + "Directive")[0]
    attrs[name.component] = value  if value isnt `undefined`

    if scope.widget.component is 'videoBox'
      scope.widget.dataSizey = parseInt attrs.sizey

    $http.get(directive.templateUrl)
      .then (result)->
        a = $compile(result.data)(scope)
        element.replaceWith a
        directive.compile(element, attrs, null)(scope, element, attrs)
])