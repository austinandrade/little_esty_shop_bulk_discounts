require 'rails_helper'

RSpec.describe 'merchant bulk discounts new' do
  before :each do
    @merchant = Merchant.create!(name: 'Hair Care')

    visit new_merchant_bulk_discount_path(@merchant)
  end

  context "given valid data" do
    it "submits the new form displays the bulk discount" do
      expect(page).to have_content('New Bulk Discount')

      expect(find('form')).to have_content('Name')
      expect(find('form')).to have_content('Percentage discount')
      expect(find('form')).to have_content('Quantity threshold')

      fill_in('Name', with: '5 percent off 6 items')
      fill_in('Percentage discount', with: 5)
      fill_in('Quantity threshold', with: 6)

      click_button 'submit'

      expect(page).to have_current_path(merchant_bulk_discounts_path(@merchant))
      expect(page).to have_content('5 percent off 6 items')
      expect(page).to have_content('bulk discount successfully created!')
    end
  end

  context "given invalid data" do
    it "re-renders the new form" do

      fill_in('Name', with: '')
      fill_in('Percentage discount', with: 5)
      fill_in('Quantity threshold', with: 6)
      click_button 'submit'

      expect(page).to have_current_path(new_merchant_bulk_discount_path(@merchant))
      expect(page).to have_content("Error: Name can't be blank")
    end
  end
end
