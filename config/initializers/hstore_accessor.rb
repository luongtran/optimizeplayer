module HstoreAccessor
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def hstore_accessor(hstore_attribute, keys, type=:string)
      serialize hstore_attribute, ActiveRecord::Coders::Hstore

      if type == :bool
        validates *keys.flatten, inclusion: {in: [true, false, "true", "false", nil]}
      end

      Array(keys).flatten.each do |key|

        attr_accessible key

        scope "has_#{key}", lambda { |value| where("#{hstore_attribute} @> hstore(?, ?)", key, value) }

        define_method("#{key}=") do |value|
          send("#{hstore_attribute}=", (send(hstore_attribute) || {}).merge(key.to_s => value))
          send("#{hstore_attribute}_will_change!")
        end
        define_method(key) do
          send(hstore_attribute) && send(hstore_attribute)[key.to_s]
        end
      end
    end
  end
end

ActiveRecord::Base.send(:include, HstoreAccessor)