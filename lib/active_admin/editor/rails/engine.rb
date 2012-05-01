module ActiveAdmin
  module Editor
    module Rails
      class Engine < ::Rails::Engine
        engine_name 'active_admin_editor'
        # initializer 'active_admin.editor' do |app|
          # ActiveAdmin.setup do |config|
            # config.register_javascript 'active_admin/editor'

            # config.register_stylesheet 'active_admin/editor'
            # config.register_stylesheet 'active_admin/editor/wysiwyg'
          # end
        # end
      end
    end
  end
end
