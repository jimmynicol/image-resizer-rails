require 'image/resizer/rails/version'
require 'image/resizer/rails/helper'
require 'image/resizer/rails/railtie' if defined?(Rails)

module Image
  module Resizer
    # Top-level module for the image-resizer code
    module Rails

      class << self
        attr_accessor :cdn, :alias_name, :js_helper_name

        def configure(&block)
          yield self
        end

        def modifiers
          @modifiers ||= {
            w: { alias: :width },  h: { alias: :height }, s: { alias: :square },
            c: { alias: :crop, values: %w(fit fill cut scale) },
            g: { alias: :gravity, values: %w(c n s e w ne nw se sw) },
            y: { alias: :top }, x: { alias: :left },
            e: { alias: :external, values: default_sources },
            f: { alias: :filter }
          }
        end

        def add_modifier(key, alias_name, values=[])
          @modifiers[key.to_sym] = {
            alias: alias_name,
            values: values
          }
        end

        def add_source(name, option)
          @modifiers[:e][:values][name.to_sym] = option.to_sym
        end

        private

        def default_sources
          {
            facebook: :fb_uid,
            twitter:  :tw_uid,
            youtube:  :youtube_id,
            vimeo:    :vimeo_id
          }
        end
      end
    end
  end
end
