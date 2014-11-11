Object.class_eval do

  def deep_freeze
    each(&:freeze) if respond_to?(:each)
    freeze
  end

end
