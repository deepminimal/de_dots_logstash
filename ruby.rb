require 'json'

def de_dots(obj)
  case obj
    when Hash
      obj.each_with_object({}) do |(k,v),h|
        key =
          case k
              when String then k.gsub('.', '_')
              when Symbol then k.to_s.gsub('.', '_').to_sym
            else k
          end
        h[key] = de_dots(v)
      end
    when Array
      obj.each_with_object([]) { |e,a| a << de_dots(e) }
    else
      obj
    end
end

def filter(event)

  object = de_dots(event.to_hash)
  event = LogStash::Event.new
  object.each do |k, v|
    begin
      event.set(k, v)
    end
  end
  return [ event ]

end
