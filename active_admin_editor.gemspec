$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "active_admin/editor/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "active_admin_editor"
  s.version     = ActiveAdmin::Editor::VERSION
  s.authors     = ["Eric Holmes"]
  s.email       = ["eric@ejholmes.net"]
  s.homepage    = "https://github.com/ejholmes/active_admin_editor"
  s.summary     = "Rich text editor for Active Admin using wysihtml5."
  s.description = s.summary

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.3"
  s.add_dependency "carrierwave"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec"
  s.add_development_dependency "activeadmin"
end
