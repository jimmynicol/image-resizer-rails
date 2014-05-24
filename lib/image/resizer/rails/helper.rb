module Image
  module Resizer
    module Rails
      # Series of view helpers building url strings for image-resizer endpoints
      module IrHelper

        def ir_image_tag(source, modifiers)
          raise NoCDNException if cdn.nil?

          src = parse_source(src)
        end

        def ir_bg_str(source, modifiers)
          "background-image:url(#{ir_image_tag(source,modifiers)})"
        end

        private

        def cdn
          ::Image::Resizer::Rails.cdn
        end

        def modifiers
          ::Image::Resizer::Rails.modifiers
        end

        def parse_source(src)

        end
      end

      class NoCDNException < Exception; end;
    end
  end
end
