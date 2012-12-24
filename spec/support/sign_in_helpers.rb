module SignInHelpers
  def sign_in(user)
    visit new_admin_user_session_path
    fill_in 'Email', :with => user.email
    fill_in 'Password', :with => user.password
    click_on 'Login'
  end
end

RSpec.configure do |config|
  config.include SignInHelpers, :type => :request
end
