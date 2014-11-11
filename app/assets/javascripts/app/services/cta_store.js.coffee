angular.module('optimizePlayer').factory 'CtaStore', ['$http', '$q', ($http, $q) ->
  promise: false;
  currentCta: false

  get: (project_cid) ->
    that = this
    if (!that.promise)
      that.promise = $http.get("/api/v2/projects/#{project_cid}/ctas")
      .success (data) ->
        angular.extend that, data
    else
      return that.promise

  all: ->
    ctas = []
    ctas = ctas.concat(this.buttons)
    ctas = ctas.concat(this.htmls)
    ctas = ctas.concat(this.surveys)
    ctas = ctas.concat(this.optins)
    ctas = ctas.concat(this.purchases)
    ctas = ctas.concat(this.tags)
    ctas


  typeToCollection: (type) ->
    mapping = {}
    mapping['CtaButton']   = this.buttons
    mapping['CtaHtml']     = this.htmls
    mapping['CtaOptin']    = this.optins
    mapping['CtaSurvey']   = this.surveys
    mapping['CtaPurchase'] = this.purchases
    mapping['CtaTag']      = this.tags
    return mapping[type]

  getPosition: (cta) -> #FIXME
    @typeToCollection(cta.type).indexOf(cta) + 1

  delete: (cta) ->
    collection = @typeToCollection(cta.type)
    collection.splice(collection.indexOf(cta), 1)
]
