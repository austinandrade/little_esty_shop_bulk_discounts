require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "validations" do
    it { should validate_presence_of :status }
    it { should validate_presence_of :customer_id }
  end
  describe "relationships" do
    it { should belong_to :customer }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many :transactions}
  end

  before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')
    @bd_1 = @merchant1.bulk_discounts.create!(name: '25 percent off 10 items', percentage_discount: 25, quantity_threshold: 10)
    @bd_2 = @merchant1.bulk_discounts.create!(name: '50 percent off 15 items', percentage_discount: 50, quantity_threshold: 15)

    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
    @item_2 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
    @item_3 = Item.create!(name: "Scissors", description: "Snips like no other", unit_price: 5, merchant_id: @merchant1.id)

    @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")

    @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 10, unit_price: 50, status: 2)
    @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 15, unit_price: 2, status: 1)
    @ii_3 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_3.id, quantity: 5, unit_price: 10, status: 1)
  end


  describe "instance methods" do
    it "total_revenue_without_discounts" do
      merchant1 = Merchant.create!(name: 'Hair Care')
      item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: merchant1.id, status: 1)
      item_2 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: merchant1.id)
      customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      invoice_1 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      ii_1 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 9, unit_price: 10, status: 2)
      ii_11 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_2.id, quantity: 1, unit_price: 10, status: 1)

      expect(invoice_1.total_revenue_without_discounts).to eq(100)
    end

    describe "#total_revenue_with_discounts" do
      it "returns total revenue for an invoice with discounts applied" do
        expect(@invoice_1.total_revenue_with_discounts).to eq(440)
      end
    end
    describe "#name_of_applied_discount" do
      it "returns the name of the greatest percentage discount applied to an invoice item" do
        expect(@invoice_1.name_of_applied_discount(@ii_1.id)).to eq(@bd_1.name)
        expect(@invoice_1.name_of_applied_discount(@ii_2.id)).to eq(@bd_2.name)
        expect(@invoice_1.name_of_applied_discount(@ii_3.id)).to eq(nil)
      end
    end

    describe "#has_discounts?" do
      it "returns true if the invoice item has discounts applied to it" do
        expect(@invoice_1.has_discounts?(@ii_1.id)).to eq(true)
        expect(@invoice_1.has_discounts?(@ii_2.id)).to eq(true)
        expect(@invoice_1.has_discounts?(@ii_3.id)).to eq(false)
      end
    end

    describe "#applied_bulk_discount" do
      it "returns the bulk discount object that is applied to an invoice item if it has one" do
        expect(@invoice_1.applied_bulk_discount(@ii_1.id)).to eq(@bd_1)
        expect(@invoice_1.applied_bulk_discount(@ii_2.id)).to eq(@bd_2)
        expect(@invoice_1.applied_bulk_discount(@ii_3.id)).to eq(nil)
      end
    end
  end
end
