$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'active_admin/editor/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'active_admin_editor'
  s.version     = ActiveAdmin::Editor::VERSION
  s.authors     = ['Eric Holmes']
  s.email       = ['eric@ejholmes.net']
  s.homepage    = 'https://github.com/ejholmes/active_admin_editor'
  s.summary     = 'Rich text editor for Active Admin using wysihtml5.'
  s.description = s.summary

  s.files = Dir['{app,config,db,lib,vendor}/**/*'] + ['MIT-LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['spec/**/*']

  s.add_dependency 'rails', '>= 3.0.0'
  s.add_dependency 'carrierwave'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'activeadmin'
end
