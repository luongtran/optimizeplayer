describe "CtaStore", ->
  cta_store = undefined
  $httpBackend = undefined

  beforeEach -> 
    module("optimizePlayer")
    inject ($injector) ->
      $httpBackend = $injector.get('$httpBackend')
      cta_store = $injector.get("CtaStore")
      $httpBackend.when('GET', '/api/v2/projects/12345/ctas').respond(200, { 
        htmls:   [{type: "CtaHtml"}, {type: "CtaHtml"}], 
        optins:  [{type: "CtaOptin"}], 
        buttons: [{type: "CtaButton"}, {type: "CtaButton"}]})

  it "fetches ctas", ->
    cta_store.get(12345)
    $httpBackend.flush()
    expect(cta_store.buttons.length).toEqual(2)
    expect(cta_store.htmls.length).toEqual(2)
    expect(cta_store.optins.length).toEqual(1)
  
  it "returns positions for ctas", ->
    cta_store.get(12345)
    $httpBackend.flush()

    expect(cta_store.getPosition(cta_store.buttons[0])).toEqual(1)
    expect(cta_store.getPosition(cta_store.buttons[1])).toEqual(2)

    expect(cta_store.getPosition(cta_store.htmls[0])).toEqual(1)
    expect(cta_store.getPosition(cta_store.htmls[1])).toEqual(2)

    expect(cta_store.getPosition(cta_store.optins[0])).toEqual(1)

  it "deletes ctas", ->
    cta_store.get(12345)
    $httpBackend.flush()

    cta_store.delete(cta_store.buttons[0])
    expect(cta_store.buttons.length).toEqual(1)

    cta_store.delete(cta_store.htmls[0])
    expect(cta_store.htmls.length).toEqual(1)

    cta_store.delete(cta_store.optins[0])
    expect(cta_store.optins.length).toEqual(0)
