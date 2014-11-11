class RgbValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless !value.present? || value =~ /\s*(\d{1,3}),\s*(\d{1,3})\s*,\s*(\d{1,3})\s*/i
      record.errors[attribute] << (options[:message] || "#{value} is not valid rgb color")
    end
  end
end