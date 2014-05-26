module Image
  module Resizer
    module Rails
      class Engine < ::Rails::Engine
        initializer 'image-resizer-rails.assets.precompile' do |app|
          app.config.assets.precompile << 'image_resizer.js'
        end
      end
    end
  end
end
