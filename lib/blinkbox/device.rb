module Blinkbox
  class Device
    def initialize(json)
      json.keys.each do | key |
        instance_eval %Q({
        @#{key} = "#{json[key]}"
        Device.class_eval{attr_reader :#{key} }
      })
      end
    end

    def id
      @client_id.split(':').last
    end
  end
end
