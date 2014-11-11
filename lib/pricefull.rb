module Pricefull

  extend ActiveSupport::Concern


  module ClassMethods
    def acts_pricefully(method_name)

      class_eval %{
        attr_accessor :formatted_#{method_name}
        validates '#{method_name}', format: { :with => /^[-+]?\\d*\\.?\\d*$/ }, presence: true
      }

      define_method("formatted_#{method_name}") do
        read_attribute(method_name) ? read_attribute(method_name).abs / 100 : 0
      end

      define_method("formatted_#{method_name}=") do |new_value|
        write_attribute(method_name, (new_value.gsub(" ", "").to_f*100).round)
      end

    end
  end
end

ActiveRecord::Base.send(:include, Pricefull)