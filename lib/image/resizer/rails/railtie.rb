module Image
  module Resizer
    module Rails
      # Make the helper file available to any View
      class Railtie < ::Rails::Railtie
        config.after_initialize do
          ActionView::Base.send :include, IrHelper
        end
      end
    end
  end
end
