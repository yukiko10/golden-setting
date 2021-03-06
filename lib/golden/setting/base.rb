module Golden
  module Setting
    class Base < ActiveRecord::Base
      include Error
      include Group
      include Name
      include Value
      include FormOption
      include Action

      self.table_name = Golden::Setting.table_name

      class << self
        def without_resource
          where(resource_type: nil, resource_id: nil)
        end

        def named name
          without_resource.where(name: name)
        end

        def select_object fields = %w{name value}
          without_resource.select(fields)
        end

        def method_missing method, *args
          super method, *args
        rescue NoMethodError
          name = method.to_s
          if name =~ /=$/
            name.gsub!('=', '')
            self[name] = args.first
          elsif name =~ /\?$/
            name.gsub!('?', '')
            self.is_true? name
          else
            self[name]
          end
        end
      end

      # def initialize attributes = nil, options = {}
      #   super attributes, options
      # end
    end
  end
end
