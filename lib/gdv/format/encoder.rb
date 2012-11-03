require 'iconv' unless String.method_defined?(:encode)

module GDV::Format

    # A wrapper around iconv for converting character encodings. We need
    # the wrapper since iconv can not be serialized with YAML. The target
    # character encoding is always UTF-8
    class Encoder
        attr_reader :source

        def initialize(source)
            @source = source
        end

        def convert(s)
            if String.method_defined?(:encode)
              s.encode('UTF-8', source)
            else
              @conv ||= Iconv.new("UTF-8", source)
              @conv.iconv(s)
            end
        end

        def self.utf8(source)
            @encoders ||= {}
            unless @encoders[source]
                @encoders[source] = Encoder.new(source)
            end
            @encoders[source]
        end
    end
end
