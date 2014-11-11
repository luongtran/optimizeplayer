angular.module("analytics").directive "analyticsWidgets", ->
  scope: false
  link: ($scope, $element) ->
    # Configure the Keen object with your Project ID and (optional) access keys.
    Keen.configure
      projectId: "52ec388b05cd66719f00000b"
      readKey: "1dbf8f32f41679ff626aaf27cc238861ae7ca7425e248a64e2da9d0f95a6d166418a24567e4aeb84c9853090825eeddcc91a7c94cb0d3de97f37a295661ba8a1c37fc71852e7e1557137a0d75810bd8a6d58bf271319d8b7962a15992cbd54c91d1851a725d0cbeb0b18f96fc9dc5fc7"

    Keen.onChartsReady ->
      
      if $scope.analytics.project_cid
        #Unique views
        uniqueViewsMetric = new Keen.Metric("#{$scope.analytics.project_cid}",
          analysisType: "count_unique"
          targetProperty: "session"
        )
        new Keen.Number(uniqueViewsMetric,
          label: "Unique viewers"
        ).draw document.getElementById("unique-views")
        
        #Completitions
        completionsMetric = new Keen.Metric("#{$scope.analytics.project_cid}",
          analysisType: "count"
          filters: [
            property_name: "type"
            operator: "eq"
            property_value: "finish"
          ]
        )
        new Keen.Number(completionsMetric,
          label: "Completions"
          "number-background-color": "rgb(43, 241, 51)"
          "label-background-color": "rgb(43, 241, 51)"
        ).draw document.getElementById("completions-count")

        #Loads
        loadsMetric = new Keen.Metric("#{$scope.analytics.project_cid}",
          analysisType: "count"
          filters: [
            property_name: "type"
            operator: "eq"
            property_value: "load"
          ]
        )
        
        #Plays
        playsMetric = new Keen.Metric("#{$scope.analytics.project_cid}",
          analysisType: "count"
          filters: [
            property_name: "type"
            operator: "eq"
            property_value: "start"
          ]
        )

        #Mobile plays
        mobileMetric = new Keen.Metric("#{$scope.analytics.project_cid}",
          analysisType: "count",
          filters: [
            {
              property_name: "type"
              operator: "eq"
              property_value: "start" 
            },
            {
              property_name: "mobile"
              operator: "eq"
              property_value: true
            }
          ]
        )

        # Play rate calculation
        loadsMetric.getResponse (response) ->
          numberOfLoads = response.result
          new Keen.Number(loadsMetric,
            label: "Page loads"
            "number-background-color": "rgb(41, 109, 126)"
            "label-background-color": "rgb(41, 109, 126)"
          ).draw document.getElementById("total-loads"),
            result: numberOfLoads

          playsMetric.getResponse (response) ->
            numberOfPlays = response.result

            mobileMetric.getResponse (response) ->
              new Keen.Number(mobileMetric,
                label: "Mobile Plays"
                "number-background-color": "rgb(194, 119, 204)"
                "label-background-color": "rgb(194, 119, 204)"
              ).draw document.getElementById("mobile-plays"), 
                result: response.result

              new Keen.Number(mobileMetric,
                label: "Desktop Plays"
                "number-background-color": "rgb(41, 109, 126)"
                "label-background-color": "rgb(41, 109, 126)"
              ).draw document.getElementById("desktop-plays"),
                result: numberOfPlays - response.result


            new Keen.Number(playsMetric,
              label: "Plays"
              "number-background-color": "rgb(194, 119, 204)"
              "label-background-color": "rgb(194, 119, 204)"
            ).draw document.getElementById("total-plays"),
              result: numberOfPlays
            
            #Play rate
            new Keen.Number(playsMetric,
              label: "Play rate"
              suffix: "%"
              "number-background-color": "rgb(204, 119, 136)"
              "label-background-color": "rgb(204, 119, 136)"
            ).draw document.getElementById("play-rate"),
              result: numberOfPlays * 100 / numberOfLoads

          #Countries stats
          countriesDistrubution = new Keen.Metric("#{$scope.analytics.project_cid}",
            analysisType: "count"
            groupBy: "location.country"
            filters: [
              property_name: "location.country"
              operator: "exists"
              property_value: true
            ,
              property_name: "type"
              operator: "eq"
              property_value: "start"
            ]
          )

          new Keen.PieChart(countriesDistrubution,
              # height: 300,
              # width: 600,
              # minimumSlicePercentage: 5,
              backgroundColor: "transparent",
              title: "Plays by country",
          ).draw document.getElementById("countries-distribution")
