module Image
  module Resizer
    module Rails
      class Railtie < ::Rails::Railtie
        config.after_initialize do
          ActionView::Base.send :include, IrHelper
        end
      end
    end
  end
end
