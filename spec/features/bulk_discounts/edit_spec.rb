require 'rails_helper'

RSpec.describe 'merchant bulk discounts show' do
  before :each do
    @merchant = Merchant.create!(name: 'Hair Care')
    @bulk_discount = @merchant.bulk_discounts.create!(name: '25 percent off 10 items', percentage_discount: 25, quantity_threshold: 10)

    visit ("/merchant/#{@merchant.id}/bulk_discounts/#{@bulk_discount.id}/edit")
  end

  it 'renders prefilled form ' do
    expect(find('form')).to have_content('Name')
    expect(find('form')).to have_content('Percentage discount')
    expect(find('form')).to have_content('Quantity threshold')

    expect(page).to have_field('Name', with: "#{@bulk_discount.name}")
    expect(page).to have_field('Percentage discount', with: "#{@bulk_discount.percentage_discount}")
    expect(page).to have_field('Quantity threshold', with: "#{@bulk_discount.quantity_threshold}")
  end

  context "given valid data" do
    it "submits the edit form and updates the bulk discount" do

      fill_in('Name', with: '15 percent off 20 items')
      fill_in('Percentage discount', with: 15)
      fill_in('Quantity threshold', with: 20)
      click_button("submit")

      expect(current_path).to eq(merchant_bulk_discount_path(@merchant, @bulk_discount))

      expect(page).to have_content("successfully updated!")
      expect(page).to_not have_content("#{@bulk_discount.name}")
      expect(page).to have_content('successfully updated!')
      expect(page).to have_content('15 percent off 20 items')
    end
  end

  context "given invalid data" do
    it 're-renders the edit form' do

      fill_in('Name', with: '')
      fill_in('Percentage discount', with: 5)
      fill_in('Quantity threshold', with: 6)
      click_button 'submit'

      expect(page).to have_content("Error: Name can't be blank")
      expect(page).to have_current_path("/merchant/#{@merchant.id}/bulk_discounts/#{@bulk_discount.id}/edit")
    end
  end
end
