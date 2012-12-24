module ActiveAdmin
  module Editor
    module Rails
      class Engine < ::Rails::Engine
        engine_name 'active_admin_editor'
        config.generators do |g|
          g.test_framework      :rspec,        :fixture => false
          g.fixture_replacement :factory_girl, :dir => 'spec/factories'
          g.assets false
          g.helper false
        end
      end
    end
  end
end
