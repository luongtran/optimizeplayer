require 'nokogiri'
module ProjectsHelper

  def optin(project)
    if project.optin.present?
      html = Nokogiri::HTML(project.optin.html)
      form = html.css("form")

      if form.empty?
        "<div id='#{project.optin.type}#{project.optin.id}'></div>"
      else
        action = form.attribute("action")
        hidden_fields = html.css("input[type=hidden]").to_s
        skip_btn = (project.optin.skip === true or project.optin.skip == 'true') ? '<div class="skip-btn"></div>' : ''
        left, right, top, bottom = (project.optin.fullscreen == 'false') ?
            [project.optin.left, project.optin.right, project.optin.top, project.optin.bottom] : ['0','0','0','0']

        %Q{<form method="post" action="#{action}" id="#{cta_css_id project.optin}" class="cta #{project.optin.position} #{project.optin.location}"
            style="display: none;
            background-image: none;">
            <div class="optin #{'fullscreen' if project.optin.fullscreen != 'false'}"
              style="background: rgba(#{project.optin.background_color},#{project.optin.background_opacity});
                          left: #{left};
                         right: #{right};
                           top: #{top};
                        bottom: #{bottom}">
              #{skip_btn}
              <div class="optin-form">
                <p style="color:rgba(#{project.optin.text_color},#{project.optin.text_opacity});
                      font-size: #{project.optin.font_size};
                      font-family: #{project.optin.font_family};
                      font-weight: #{project.optin.font_style}">#{project.optin.header_text}</p>
                <div class="input-append clearfix" style="margin-top:8px">
                  <input name="email" type="text" placeholder="your email" style="font-size:20px;padding-left:5px;box-sizing:border-box;float:left;width:75%;height:40px;border:none;border-radius:4px 0 0 4px;">
                  <button style="background: rgba(#{project.optin.button_background_color}, #{project.optin.button_background_opacity});float:left;border-radius:0 4px 4px 0;color:rgba(#{project.optin.text_color},#{project.optin.text_opacity});width:25%;height:40px;border:none;font-weight:bold;" type="submit">#{project.optin.text}</button>
                </div>
              </div>
            </div>
        #{hidden_fields}<span style='clear:both; opacity: 0;'>.</span></form>}
      end
    else
      ""
    end
  end

  def cta_css_id(cta)
    cta.type + cta.id.to_s + cta.position + ((cta.position == 'inside') ? '' : cta.location)
  end

  def add_to_style(options, names, style_params)
    styles = []
    key = 0
    unless names.blank?
      names.each do |name|
        unless options[name].blank?
          if name == "fontSize"
            styles.push("#{style_params[key]}: #{options[name]}px;")
          else
            styles.push("#{style_params[key]}: #{options[name]};")
          end
        end
        key += 1
      end
    end
    styles.join(' ')
  end
end