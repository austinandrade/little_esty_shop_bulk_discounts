require 'rails_helper'

RSpec.describe 'merchant bulk discounts show' do
  before :each do
    @merchant = Merchant.create!(name: 'Hair Care')
    @bulk_discount = @merchant.bulk_discounts.create!(name: '25 percent off 10 items', percentage_discount: 25, quantity_threshold: 10)

    visit merchant_bulk_discount_path(@merchant, @bulk_discount)
  end

  it "displays bulk discount's attributes and which merchant it's for" do
    expect(page).to have_content(@bulk_discount.name)
    expect(page).to have_content(@bulk_discount.percentage_discount)
    expect(page).to have_content(@bulk_discount.quantity_threshold)
  end

  it "clicks edit link and redirects to edit page" do
    expect(page).to have_link("Edit")
    click_link("Edit")

    expect(page).to have_current_path("/merchant/#{@merchant.id}/bulk_discounts/#{@bulk_discount.id}/edit")
  end
end
