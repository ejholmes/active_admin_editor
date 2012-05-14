module ActiveAdmin
  module Editor
    module Rails
      class Engine < ::Rails::Engine
        engine_name 'active_admin_editor'
        config.after_initialize do
          require 'active_admin/editor/admin/assets'
        end
      end
    end
  end
end
