require 'uri'

module Image
  module Resizer
    module Rails
      # Series of view helpers building url strings for image-resizer endpoints
      module IrHelper
        def ir_image_tag(*args)
          src = generate_ir_endpoint(args)
        end

        def ir_background(*args)
          url = generate_ir_endpoint(args)
          "background-image:url(#{url})"
        end

        def ir_url(*args)
          generate_ir_endpoint(args)
        end

        def self.included(base)
          if ::Image::Resizer::Rails.image_tag_name
            self.singleton_class.send(
              :alias_method,
              ::Image::Resizer::Rails.image_tag_name,
              :ir_image_tag
            )
          end
        end

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

        def mods
          ::Image::Resizer::Rails.modifiers
        end

        def mod_set(key)
          mods.each do |k, v|
            return v if k == v || v[:alias] == key
          end
          nil
        end

        def sources
          mods[:e][:values]
        end

        def source_option(key)
          sources.each do |k, v|
            return [k,v] if key == v
          end
          nil
        end

        def generate_ir_endpoint(args)
          fail NoCDNException if cdn.nil?

          source, modifiers = parse_arguments(args)
          modifier_str = mod_str(modifiers)
          path = build_path(source, modifiers)

          "#{cdn.gsub(/\/$/, '')}#{modifier_str}#{path}"
        end

        def mod_str(modifiers)
          return '' if modifiers.nil? || modifiers[0].nil?
          mod_arr = modifiers[0].map do |k, v|
            if mset = mod_set(k)
              if mset.include? :values
                mset[:values].include?(v) ? "#{k}#{v}" : nil
              else
                "#{k}#{v}"
              end
            elsif src = source_option(k)
              "e#{src.first}"
            else
              nil
            end
          end
          mod_arr.compact
          mod_arr.length > 0 ? "/#{mod_arr.join('-')}" : ''
        end

        def build_path(source, modifiers)
          if source
            uri = URI source
            case url_domain(uri.host)
            when :s3
              s3_object uri
            when :facebook
              "#{fb_uid(uri)}.jpg"
            else
            end
          else

          end
        end

        def url_domain(host)
          return :s3 if /s3.amazonaws.com/i =~ host
          return :facebook if /facebook.com/i =~ host
          :other
        end

        def s3_object(uri)
          # test to see which type of s3 url we have
          obj = if uri.host == 's3.amazonaws.com'
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
    end
  end
end
