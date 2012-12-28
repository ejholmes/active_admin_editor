require 'spec_helper'

describe 'Pages', :js => true do
  before do
    sign_in create(:admin_user)
  end

  it 'does something' do
    visit new_admin_page_path
    expect(current_path).to eq(new_admin_page_path)
  end
end
