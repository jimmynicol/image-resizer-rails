require 'uri'

module Image
  module Resizer
    module Rails
      # Series of view helpers building url strings for image-resizer endpoints
      module IrHelper
        def ir_image_tag(*args)
          src = generate_ir_endpoint(args)
          if respond_to?(:image_tag)
            image_tag src
          else
            "<img src='#{src}' data-something='else' />"
          end
        end

        def ir_background(*args)
          url = generate_ir_endpoint(args)
          "background-image:url(#{url})"
        end

        def ir_url(*args)
          generate_ir_endpoint(args)
        end

        # def self.included(base)
        #   base.class_eval do
        #     if ::Image::Resizer::Rails.image_tag_name
        #       alias_method ::Image::Resizer::Rails.image_tag_name, :ir_image_tag
        #     end
        #     unless method_defined?(:image_tag)
        #       if defined?(ActionView)
        #         include ::ActionView::Helpers::AssetTagHelper
        #       end
        #     end
        #   end
        # end

        private

        def parse_arguments(args)
          if args[0].is_a?(String)
            [args[0], args[1..-1]]
          else
            [nil, args]
          end
        end

        def cdn
          ::Image::Resizer::Rails.cdn
        end

        def self.img_tag_name
          ::Image::Resizer::Rails.image_tag_name
        end

        def mods
          ::Image::Resizer::Rails.modifiers
        end

        def mod_set(key)
          mods.each do |k, v|
            return v if key == k || v[:alias] == key
          end
          nil
        end

        def sources
          mods[:e][:values]
        end

        def source_option(key)
          sources.each do |k, v|
            return [k, v] if key == v
          end
          nil
        end

        def generate_ir_endpoint(args)
          fail NoCDNException if cdn.nil?

          source, modifiers = parse_arguments(args)
          uri = source ? URI(source) : nil
          modifier_str = mod_str(uri, modifiers)
          path = build_path(uri, modifiers)

          "#{cdn.gsub(/\/$/, '')}#{modifier_str}#{path}"
        end

        def mod_str(uri, modifiers)
          mod_arr = []
          unless modifiers.nil? || modifiers[0].nil?
            mod_arr = build_mod_arr(modifiers)
          end
          mod_arr << 'efacebook' if uri && url_domain(uri.host) == :facebook
          mod_arr.compact
          mod_arr.length > 0 ? "/#{mod_arr.join('-')}" : ''
        end

        def build_mod_arr(modifiers)
          modifiers[0].map do |k, v|
            mset = mod_set(k)
            src = source_option(k)
            if mset
              if mset.include? :values
                mset[:values].include?(v) ? "#{k}#{v}" : nil
              else
                "#{k}#{v}"
              end
            elsif src
              "e#{src.first}"
            else
              nil
            end
          end
        end

        def build_path(uri, modifiers)
          if uri
            case url_domain(uri.host)
            when :s3
              s3_object uri
            when :facebook
              "/#{fb_uid(uri)}.jpg"
            else
            end
          else
            modifiers[0].each do |k, v|
              return "/#{v}.jpg" if source_option(k)
            end
            nil
          end
        end

        def url_domain(host)
          return :s3 if /s3.amazonaws.com/i =~ host
          return :facebook if /facebook.com/i =~ host
          :other
        end

        def s3_object(uri)
          # test to see which type of s3 url we have
          if uri.host == 's3.amazonaws.com'
            # this version has the bucket at the first part of the path
            "/#{uri.path.split('/')[2..-1].join('/')}"
          else
            # this version has the bucket included in the host
            uri.path
          end
        end

        def fb_uid(uri)
          uri.path.split('/')[1]
        end
      end

      class NoCDNException < Exception; end
      class NotS3SourceException < Exception; end
    end
  end
end
