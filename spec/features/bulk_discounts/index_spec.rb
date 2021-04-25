require 'rails_helper'

RSpec.describe 'merchant bulk discounts index' do
  before :each do
    @merchant_1 = Merchant.create!(name: 'Hair Care')
    @merchant_2 = Merchant.create!(name: 'Body Care')

    @bulk_discount_1 = @merchant_1.bulk_discounts.create!(name: '25 percent off 10 items', percentage_discount: 25, quantity_threshold: 10)
    @bulk_discount_2 = @merchant_1.bulk_discounts.create!(name: '50 percent off 15 items', percentage_discount: 50, quantity_threshold: 15)
    @bulk_discount_3 = @merchant_1.bulk_discounts.create!(name: '75 percent off 20 items', percentage_discount: 75, quantity_threshold: 20)
    @bulk_discount_4 = @merchant_1.bulk_discounts.create!(name: '40 percent off 6 items', percentage_discount: 40, quantity_threshold: 6)

    @bulk_discount_5 = @merchant_2.bulk_discounts.create!(name: '10 percent off 2 items', percentage_discount: 10, quantity_threshold: 2)


    visit merchant_bulk_discounts_path(@merchant_1)
  end

  it 'displays all bulk discounts for the merchant and their attributes' do
    within("#bulk_discount-#{@bulk_discount_1.id}") do
      expect(page).to have_link(@bulk_discount_1.name)
      expect(page).to have_content(@bulk_discount_1.percentage_discount)
      expect(page).to have_content(@bulk_discount_1.quantity_threshold)
    end

    within("#bulk_discount-#{@bulk_discount_2.id}") do
      expect(page).to have_link(@bulk_discount_2.name)
      expect(page).to have_content(@bulk_discount_2.percentage_discount)
      expect(page).to have_content(@bulk_discount_2.quantity_threshold)
    end

    within("#bulk_discount-#{@bulk_discount_3.id}") do
      expect(page).to have_link(@bulk_discount_3.name)
      expect(page).to have_content(@bulk_discount_3.percentage_discount)
      expect(page).to have_content(@bulk_discount_3.quantity_threshold)
    end

    within("#bulk_discount-#{@bulk_discount_4.id}") do
      expect(page).to have_link(@bulk_discount_4.name)
      expect(page).to have_content(@bulk_discount_4.percentage_discount)
      expect(page).to have_content(@bulk_discount_4.quantity_threshold)
    end

    expect(page).to_not have_content(@bulk_discount_5.name)
  end

  it 'clicks bulk discount name and redirects to its show page' do
    within("#bulk_discount-#{@bulk_discount_1.id}") do
      click_link(@bulk_discount_1.name)
    end

    expect(current_path).to eq("/merchant/#{@merchant_1.id}/bulk_discounts/#{@bulk_discount_1.id}")
  end

  it 'displays the names of the next 3 us holidays' do
    within("#upcoming_holidays") do
      expect(page).to have_content("Memorial Day")
      expect(page).to have_content("Independence Day")
      expect(page).to have_content("Labour Day")
    end
  end
end
