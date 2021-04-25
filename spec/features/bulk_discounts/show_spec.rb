require 'rails_helper'

RSpec.describe 'merchant bulk discounts show' do
  before :each do
    @merchant_1 = Merchant.create!(name: 'Hair Care')

    @bulk_discount_1 = @merchant_1.bulk_discounts.create!(name: '25 percent off 10 items', percentage_discount: 25, quantity_threshold: 10)

    visit merchant_bulk_discount_path(@merchant_1, @bulk_discount_1)
  end

  it "displays bulk discount's attributes and which merchant it's for" do
    expect(page).to have_content(@bulk_discount_1.name)
    expect(page).to have_content(@bulk_discount_1.percentage_discount)
    expect(page).to have_content(@bulk_discount_1.quantity_threshold)
    expect(page).to have_content(@bulk_discount_1.merchant.name)
  end
end
