describe "CtasCtrl", ->
  $httpBackend = undefined
  controller = undefined
  $q = undefined
  $rootScope = {}
  $controller = undefined

  beforeEach -> 
    module("optimizePlayer")
    inject ($injector, _$q_, _$rootScope_, _$controller_) ->
      $q = _$q_
      $rootScope = _$rootScope_
      $rootScope.project = {cid: 12345}
      $rootScope.initPlayer = -> return null

      $controller = _$controller_
      $httpBackend = $injector.get('$httpBackend')

      $httpBackend.when('GET', '/api/v2/projects/12345/ctas').respond(200, { 
        htmls:   [{type: "CtaHtml"}, {type: "CtaHtml"}], 
        optins:  [{type: "CtaOptin"}], 
        buttons: [{type: "CtaButton"}, {type: "CtaButton"}]});
    
      $httpBackend.when('POST', '/api/v1/projects/12345/ctas').respond(200, {})

  it "builds cta by type", ->
    scope = $rootScope.$new()
    ctas_controller = $controller("CtasCtrl", {$scope: scope})

    scope.cta_store.get(12345)
    $httpBackend.flush()

    scope.$apply -> scope.addCta("button")
    expect(scope.cta_store.currentCta.type).toBe("CtaButton")

    scope.$apply -> scope.addCta("html")
    expect(scope.cta_store.currentCta.type).toBe("CtaHtml")

    scope.$apply -> scope.addCta("optin")
    expect(scope.cta_store.currentCta.type).toBe("CtaOptin")

  it "removes unsaved cta if another one is added", ->
    scope = $rootScope.$new()
    ctas_controller = $controller("CtasCtrl", {$scope: scope})
    scope.cta_store.get(12345)
    $httpBackend.flush()

    scope.$apply -> 
      scope.addCta("button")
      scope.addCta("html")
    
    expect(scope.cta_store.buttons.length).toEqual(2)

  it "saves cta", ->
    scope = $rootScope.$new()
    ctas_controller = $controller("CtasCtrl", {$scope: scope})
    
    scope.cta_store.get(12345)
    $httpBackend.flush()

    scope.cta_store.currentCta = {type: "CtaButton", on_pause: "true"}
    scope.saveCta()

    $httpBackend.flush()

    expect(scope.cta_store.currentCta).toBe(false)




