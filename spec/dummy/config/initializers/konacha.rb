Konacha.configure do |config|
  require 'capybara/poltergeist'
  config.driver      = :poltergeist

  def Konacha.spec_root
    File.expand_path('../../../../../spec/javascripts', __FILE__)
  end

  Rails.application.config.assets.paths << Konacha.spec_root
end if defined?(Konacha)
