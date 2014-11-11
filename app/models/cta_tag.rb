class CtaTag < Cta
  hstore_accessor :options, %i(title sub_title image link button_text description sub_description)
end