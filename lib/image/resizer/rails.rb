require 'image/resizer/rails/version'
require 'image/resizer/rails/helper'
require 'image/resizer/rails/engine' if defined?(Rails)

module Image
  module Resizer
    # Top-level module for the image-resizer code
    module Rails
      class << self
        attr_accessor :cdn, :js_helper_name
        attr_writer :js_class_name, :image_tag_name

        def configure(&block)
          yield self
        end

        def reset_config
          @cdn = nil
          @image_tag_name = nil
          @js_helper_name = nil
          @modifiers = default_modifiers
        end

        def modifiers
          @modifiers ||= default_modifiers
        end

        def add_modifier(key, img_tag = '', values = [])
          @modifiers[key.to_sym] = { alias: img_tag, values: values }
        end

        def add_source(name, option)
          @modifiers[:e][:values][name.to_sym] = option.to_sym
        end

        def image_tag_name=(value)
          @image_tag_name = value
          Helper.class_eval do |base|
            base.send(:alias_method, value.to_sym, :ir_image_tag)
          end
        end

        def js_class_name
          @js_class_name ||= 'ImageResizer'
        end

        def to_hash
          {
            cdn: cdn,
            image_tag_name: image_tag_name,
            js_helper_name: js_helper_name,
            modifiers: modifiers
          }
        end

        private

        def default_modifiers
          {
            w: { alias: :width },  h: { alias: :height },
            s: { alias: :square },
            c: { alias: :crop, values: %w(fit fill cut scale) },
            g: { alias: :gravity, values: %w(c n s e w ne nw se sw) },
            y: { alias: :top }, x: { alias: :left },
            e: { alias: :external, values: default_sources },
            f: { alias: :filter }
          }
        end

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
