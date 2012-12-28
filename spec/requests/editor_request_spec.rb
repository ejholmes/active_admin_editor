require 'spec_helper'

describe 'Editor', :js => true do
  before do
    sign_in create(:admin_user)
    visit new_admin_page_path
  end

  it 'adds the input as an html_editor input' do
    expect(page).to have_selector('li.html_editor')
  end

  it 'intitalizes the editor' do
    expect(page).to have_selector('li.html_editor .toolbar')
  end
end
