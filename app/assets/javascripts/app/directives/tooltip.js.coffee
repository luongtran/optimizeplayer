angular.module("optimizePlayer").directive "tooltip", ->
  link: ($scope, $element, $attrs) ->
    $(".use-tooltip", $element).on("mouseenter", ->
      type = $(this).data("tooltip")
      title = $(this).data("title")
      tooltip = $("#tooltip-" + type)
      $(this).append tooltip
      $(tooltip).find("span").html(title).end().stop().fadeIn 250
    ).on "mouseleave", ->
      tooltip = $(this).data("tooltip")
      $("#tooltip-" + tooltip).stop().fadeOut 250
