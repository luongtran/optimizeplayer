angular.module('optimizePlayer').controller 'CtasCtrl', ['$scope', '$http', '$rootScope', 'CtaStore', '$timeout', 'Integration', ($scope, $http, $rootScope, CtaStore, $timeout, Integration) ->
  $scope.cta_store = CtaStore
  $scope.disableSave = false
  $scope.cta = {}

  $scope.ctaTemplate = {
    left_background_color: "28,168,221"
    left_background_color_opacity: "1"
    right_background_color: "43,195,227"
    right_background_color_opacity: "1"
    cuepoints: []
    font_size: "26px"
    fullscreen: true
    link: "http://google.com"
    on_cuepoints: false
    on_finish: false
    on_pause: false
    on_start: false
    location: ""
    position: "inside"
    text: "Play Video"
    text_color: "255,255,255"
    text_opacity: "1"
  }

  $scope.$watch 'cta_store.currentCta', (cta) ->
    optimizeplayer.player.pause() if $scope.player
    if cta.type == "CtaPurchase" && cta.delivery_method == 'play_video'
      cta.on_start = true
      cta.on_cuepoints = false
      cta.on_pause = false
      cta.on_finish = false
  , true

  $scope.$watch 'cta_store.currentCta.fullscreen', ->
    if isTrue($scope.cta_store.currentCta.fullscreen)
      $scope.cta_store.currentCta.width = null
      $scope.cta_store.currentCta.height = null

  prev_location = null
  $scope.$watch 'cta_store.currentCta.position', ->
    setCorrectPosition $scope.cta_store.currentCta, prev_location

  $scope.$watch 'cta_store.currentCta.integration_id', ->
    integration_id = parseInt($scope.cta_store.currentCta.integration_id)
    if integration_id
      integration = $scope.getIntegrationByID(integration_id)[0]
      $scope.setProviderList(integration);
    else
      $scope.cta.mailchimp_lists = []
      $scope.cta.aweber_lists = []
      $scope.cta.getresponse_campaigns = []
      $scope.cta.integration_provider = null
      $scope.cta_store.currentCta.list_id = Math.random(500,600)

  $scope.initCta = ->
    # Pull all integrations
    @integrationService = new Integration()
    @integrationService.query().then((response) ->
      $rootScope.integrations = response
    )

  $scope.setCta = (cta) ->
    if cta.type == 'CtaOptin'
      integration = $scope.getIntegrationByID(cta.integration_id)[0]
      $scope.setProviderList(integration);

    $scope.cta_store.currentCta = cta

  $scope.setProviderList = (integration) ->
    if integration
      switch integration.provider
        when 'mailchimp'
          @integrationService.loadMailChimpLists(integration.id).then((response) ->
            $scope.cta.mailchimp_lists = response.data
            $scope.cta.integration_provider = 'mailchimp'
            $scope.action = true
            return
          )
        when 'aweber'
          @integrationService.loadAweberLists(integration.id).then((response) ->
            $scope.cta.aweber_lists = response.data
            $scope.cta.integration_provider = 'aweber'
            return
          )
        when 'getresponse'
          @integrationService.loadGetresponseCampaigns(integration.id).then((response) ->
            $scope.cta.getresponse_campaigns = response.data
            $scope.cta.integration_provider = 'getresponse'
            return
          )
    $scope.cta_store.currentCta.list_id = Math.random(500,600)

  $scope.saveCta = ->
    x = $scope.cta_store.currentCta
    unless( isTrue(x.on_finish) or isTrue(x.on_pause) or isTrue(x.on_start) or (isTrue(x.on_cuepoints) and x.cuepoints.length) )
      alert "Choose when do you want to show CTA"
      return no
    if $scope.cta_store.currentCta.type == 'CtaSurvey'
     unless $scope.cta_store.currentCta.survey_questions_attributes.length > 0 
      alert "Add at least one question"
      return no
    if $scope.cta_store.currentCta.type == 'CtaOptin'
      if $scope.cta_store.currentCta.integration_id == null || $scope.cta_store.currentCta.integration_id == 0 || 
         $scope.cta_store.currentCta.integration_id == 'none' || $scope.cta_store.currentCta.integration_id == undefined
        alert "Select email provider"
        return no
    unless $scope.disableSave
      $scope.disableSave = true
      if $scope.cta_store.currentCta.id
        $http.put("/api/v1/projects/#{$scope.project.cid}/ctas/#{$scope.cta_store.currentCta.id}", {cta: $scope.cta_store.currentCta})
        .success (data) ->
          angular.extend $scope.cta_store.currentCta, data
          $scope.cta_store.currentCta = false
          $scope.initPlayer()
          $scope.disableSave = false
      else
        $http.post("/api/v1/projects/#{$scope.project.cid}/ctas", {cta: $scope.cta_store.currentCta})
        .success (data) ->
          angular.extend $scope.cta_store.currentCta, data
          $scope.cta_store.currentCta = false
          $scope.initPlayer()
          $scope.disableSave = false
          # need gets all CTAs to buttons [x] (delete)
          $scope.cta_store.get($scope.project.cid)

  isTrue = (element)->
    if (element is "false" or element is false) then no else yes

  $scope.cancel = ->
    if !$scope.cta_store.currentCta.id
      CtaStore.delete($scope.cta_store.currentCta)
    $scope.cta_store.currentCta = false

  $scope.deleteCta = (cta) ->
    if confirm "Are you sure?"
      CtaStore.delete(cta)
      $http.delete("/api/v1/projects/#{$scope.project.cid}/ctas/#{cta.id}")

  setCorrectPosition = (cta, prev_location) ->
    if cta.position == 'inside'
      prev_location = cta.location
      cta.location = ""
    else
      cta.left = 0 if typeof cta.left is "undefined"
      cta.top = 0 if typeof cta.top is "undefined"
      cta.location = prev_location if prev_location

  ######################################################################################################################
  # Cta Survey
  ######################################################################################################################

  $scope.addSurveyQuestion = ->
    $scope.cta_store.currentCta.survey_questions_attributes.push({text: "", survey_options_attributes: [{text: ""}]})
    unless $rootScope.current_question
      $rootScope.current_question = $scope.cta_store.currentCta.survey_questions_attributes[0]

  $scope.removeSurveyQuestion = (question) ->
    question["_destroy"] = 1

  $scope.addSurveyOption = (question) ->
    question.survey_options_attributes.push({text: ""})

  $scope.removeSurveyOption = (option) ->
    option["_destroy"] = 1


  ######################################################################################################################
  # Cta Optin
  ######################################################################################################################

  # get integrations filtered by type(email, payment, ...)
  $scope.getIntegrationsByType = (integration_type) ->
    if $rootScope.integrations != undefined
      $rootScope.integrations.filter (i) -> i.integration_type == integration_type

  # get integrations filtered by provider(paypal, stripe, ...)
  $scope.getIntegrationsByProvider = (provider) ->
    if $rootScope.integrations != undefined
      $rootScope.integrations.filter (i) -> i.provider == provider

  $scope.getIntegrationByID = (integration_id) ->
    if $rootScope.integrations != undefined
      $rootScope.integrations.filter (i) -> i.id == integration_id

  $scope.changeProvider = (integration_id) ->
    integration = $scope.getIntegrationByID(integration_id)
    if integration
      $scope.cta.integration_provider = integration.provider
      switch integration.provider
        when 'mailchimp'
          @integrationService.loadMailChimpLists(integration.id).then((response) ->
            $scope.cta.mailchimp_lists = response.data
            return
          )
        when 'aweber'
          @integrationService.loadAweberLists(integration.id).then((response) ->
            $scope.cta.aweber_lists = response.data
            return
          )
        when 'getresponse'
          @integrationService.loadGetresponseCampaigns(integration.id).then((response) ->
            $scope.cta.getresponse_campaigns = response.data
            return
          )
    return

  $scope.addCta = (type) ->
    $scope.cta_store.promise.then (data) ->
      $scope.cta_store.delete($scope.cta_store.currentCta) if ($scope.cta_store.currentCta && !$scope.cta_store.currentCta.id)
      switch type
        when 'button'
          $scope.cta_store.currentCta = angular.extend {type: "CtaButton", cid: new Date().getTime()}, $scope.ctaTemplate
          $scope.cta_store.buttons.push($scope.cta_store.currentCta)
        when 'html'
          $scope.cta_store.currentCta = angular.extend {type: "CtaHtml", cid: new Date().getTime()}, $scope.ctaTemplate
          $scope.cta_store.htmls.push($scope.cta_store.currentCta)
        when 'optin'
          if $scope.getIntegrationsByType('email').length
            $scope.optin_link = "#cta-manage"
            $scope.cta_store.currentCta = angular.extend {
              type: "CtaOptin"
              cid: new Date().getTime()
              button_background_color: "43,195,227"
              header_text: "Enter your email to play this video"
              skip: "true"
              font_family: 'none'
              font_style: 'none'
              background_color: "92,121,128"
              background_opacity: '0.5'
              smart_optin: false}, $scope.ctaTemplate
            $scope.cta_store.optins.push($scope.cta_store.currentCta)
          else
            $scope.optin_link = "#"
            alert 'Please setup at least one email integration at Profile > Integrations'
        when 'survey'
          $scope.cta_store.currentCta = angular.extend {
            type: 'CtaSurvey'
            cid: new Date().getTime()
            survey_questions_attributes: []
            answers_bg_color: "71,71,71"
            answers_bg_color_opacity: 1
            button_bg_color: "43,195,227"
            button_bg_color_opacity: 1
            header_color: "77,137,214"
            header_color_opacity: 1
            text_color: "255,255,255"
            text_opacity: 1
            header_text: "This is your survey overlay window. You can create a pool inside your video and save the results for your statistics"
            button_text: "Submit answer"}, $scope.ctaTemplate
          $scope.cta_store.surveys.push($scope.cta_store.currentCta)
        when 'payment'
          $scope.cta_store.currentCta = angular.extend {
            type: 'CtaPurchase',
            cid: new Date().getTime(),
            title: "Product name",
            price: "9.99",
            button_bg_color: "43,195,227"
            button_bg_opacity: 1,
            title_color: "255,255,255",
            price_color: "255,255,255"}, $scope.ctaTemplate
          $scope.cta_store.purchases.push($scope.cta_store.currentCta)
        when 'tag'
          $scope.cta_store.currentCta = angular.extend {
            type: 'CtaTag',
            cid: new Date().getTime()
          }, $scope.ctaTemplate
          $scope.cta_store.tags.push($scope.cta_store.currentCta)
]