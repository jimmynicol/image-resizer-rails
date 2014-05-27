require 'image/resizer/rails/helper'

module Image
  module Resizer
    module Rails
      # Series of view helpers building url strings for image-resizer endpoints
      module IrHelper
        def self.included(base)
          base.class_eval do
            include ::Image::Resizer::Rails::Helper
          end
        end
      end
    end
  end
end
