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

    expect(current_path).to eq(merchant_bulk_discount_path(@merchant_1, @bulk_discount_1))
  end

  it 'displays the names of the next 3 us holidays' do
    next_3_holiday_names = HolidayService.new.next_3_holidays.map{|holiday| holiday[:name]}
  
    within("#upcoming_holidays") do
      expect(page).to have_content(next_3_holiday_names.first)
      expect(page).to have_content(next_3_holiday_names.second)
      expect(page).to have_content(next_3_holiday_names.third)
    end
  end

  it "displays link to create a new discount, clicks, and redirects to new page" do
    expect(page).to have_link("Create New Discount")
    click_link("Create New Discount")

    expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant_1))
  end

  it "displays delete link next to each bulk discount " do
    within("#bulk_discount-#{@bulk_discount_1.id}") do
      expect(page).to have_link("DELETE:")
    end

    within("#bulk_discount-#{@bulk_discount_2.id}") do
      expect(page).to have_link("DELETE:")
    end

    within("#bulk_discount-#{@bulk_discount_3.id}") do
      expect(page).to have_link("DELETE:")
    end

    within("#bulk_discount-#{@bulk_discount_4.id}") do
      expect(page).to have_link("DELETE:")
    end
  end

  it "clicks delete link and no longer displays that bulk discount" do
    expect(page).to have_content(@bulk_discount_1.name)

    within("#bulk_discount-#{@bulk_discount_1.id}") do
      click_link("DELETE:")
    end

    expect(page).to_not have_content(@bulk_discount_1.name)
    expect(current_path).to eq(merchant_bulk_discounts_path(@merchant_1))
  end
end
