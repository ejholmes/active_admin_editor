require 'spec_helper'

describe 'Pages', :js => true do
  before do
    sign_in create(:admin_user)
  end

  it 'does something' do
    visit admin_pages_path
    expect(current_path).to eq(admin_pages_path)
  end
end
