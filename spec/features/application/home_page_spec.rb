require 'rails_helper'

RSpec.describe 'application home page' do
  it "displays welcome message" do
    visit "/"

    expect(page).to have_content("Welcome to adopt don't shop!")
  end
end
