module ApplicationHelper
  include UrlHelper
  def google_font_link_tag(family)
    tag("link", {:rel => :stylesheet,
    :type => Mime::CSS,
    :href => "https://fonts.googleapis.com/css?family=#{family}"},
    false, false)
  end

  def default_google_fonts
    [
      # "Arial",
      # "Arial Black",
      "Adamina",
      "Alice",
      "Arvo",
      "Asap",
      "Bitter",
      "Cabin",
      "Calligraffitti",
      "Crimson Text",
      "Lato",
      "Droid Sans",
      "Montserrat",
      # "Nixie ONe",
      # "OPen Sans",
      "Oswald",
      "PT Sans",
      "Source Sans Pro",
      # "VollKorn",
      # "Titillum Web",
      # "Unbuntu",
      "Lobster Two",
      "Nixie One",
      "Old Standard TT",
      "Abril Fatface",
      "PT Serif",
      "PT Mono",
      # "JUnctio"
    ]
  end

  def get_icon type
    case type
    when "News"
      "post"
    when "Feature"
      "star-blue"
    when "Bug"
      "warning"
    end
  end
  
end
