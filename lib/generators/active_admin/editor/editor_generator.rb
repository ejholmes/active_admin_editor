module ActiveAdmin
  module Generators
    class EditorGenerator < Rails::Generators::NamedBase
      desc "Installs the wysiwyg css file for the editor"
      argument :name, type: :string, default: 'none'

      source_root File.expand_path('../templates', __FILE__)
      
      def copy_wysiwyg_css
        template 'wysiwyg.css', 'public/assets/wysiwyg.css'
      end
    end
  end
end
