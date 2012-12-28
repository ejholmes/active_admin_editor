module ActiveAdmin
  module Generators
    class EditorGenerator < Rails::Generators::Base
      desc 'Installs the active admin html5 editor.'

      source_root File.expand_path('../templates', __FILE__)
      
      def copy_initializer
        template 'active_admin_editor.rb', 'config/initializers/active_admin_editor.rb'
      end
    end
  end
end
