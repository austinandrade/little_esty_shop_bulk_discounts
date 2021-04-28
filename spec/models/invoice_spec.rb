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
      invoicea = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      ii_1 = InvoiceItem.create!(invoice_id: invoicea.id, item_id: item_1.id, quantity: 9, unit_price: 10, status: 2)
      ii_11 = InvoiceItem.create!(invoice_id: invoicea.id, item_id: item_2.id, quantity: 1, unit_price: 10, status: 1)

      expect(invoicea.total_revenue_without_discounts).to eq(100)
    end

    describe "#total_revenue_with_discounts" do
      it "returns total revenue for an invoice with discounts applied" do
        expect(@invoice_1.total_revenue_with_discounts).to eq(440)
      end
      it "test case 1" do
        # Merchant A has one Bulk Discount
        # Bulk Discount A is 20% off 10 items
        # Invoice A includes two of Merchant A’s items
        # Item A is ordered in a quantity of 5
        # Item B is ordered in a quantity of 5

        merchanta = Merchant.create!(name: 'Hair Care')
        bd_1 = merchanta.bulk_discounts.create!(name: '20 percent off 10 items', percentage_discount: 20, quantity_threshold: 10)

        item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: merchanta.id, status: 1)
        item_2 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: merchanta.id)
        item_3 = Item.create!(name: "Scissors", description: "Snips like no other", unit_price: 5, merchant_id: merchanta.id)

        customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
        invoicea = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")

        ii_1 = InvoiceItem.create!(invoice_id: invoicea.id, item_id: item_1.id, quantity: 5, unit_price: 50, status: 2)
        ii_2 = InvoiceItem.create!(invoice_id: invoicea.id, item_id: item_2.id, quantity: 5, unit_price: 2, status: 1)

        expect(invoicea.total_revenue_with_discounts).to eq(260)
        expect(ii_1.best_qualifying_discount).to eq(nil)
        expect(ii_2.best_qualifying_discount).to eq(nil)
      end

      it "test case 2" do
        # Merchant A has one Bulk Discount
        # Bulk Discount A is 20% off 10 items
        # Invoice A includes two of Merchant A’s items
        # Item A is ordered in a quantity of 10
        # Item B is ordered in a quantity of 5

        merchanta = Merchant.create!(name: 'Hair Care')
        bd_1 = merchanta.bulk_discounts.create!(name: '20 percent off 10 items', percentage_discount: 20, quantity_threshold: 10)

        item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: merchanta.id, status: 1)
        item_2 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: merchanta.id)
        item_3 = Item.create!(name: "Scissors", description: "Snips like no other", unit_price: 5, merchant_id: merchanta.id)

        customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
        invoicea = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")

        ii_1 = InvoiceItem.create!(invoice_id: invoicea.id, item_id: item_1.id, quantity: 10, unit_price: 50, status: 2)
        ii_2 = InvoiceItem.create!(invoice_id: invoicea.id, item_id: item_2.id, quantity: 5, unit_price: 2, status: 1)

        expect(invoicea.total_revenue_with_discounts).to eq(410)
        expect(ii_1.best_qualifying_discount).to eq(bd_1)
        expect(ii_2.best_qualifying_discount).to eq(nil)
      end

      it "test case 3" do
        # Merchant A has two Bulk Discounts
        # Bulk Discount A is 20% off 10 items
        # Bulk Discount B is 30% off 15 items
        # Invoice A includes two of Merchant A’s items
        # Item A is ordered in a quantity of 12
        # Item B is ordered in a quantity of 15

        merchanta = Merchant.create!(name: 'Hair Care')
        bd_1 = merchanta.bulk_discounts.create!(name: '20 percent off 10 items', percentage_discount: 20, quantity_threshold: 10)
        bd_2 = merchanta.bulk_discounts.create!(name: '30 percent off 15 items', percentage_discount: 30, quantity_threshold: 15)

        item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: merchanta.id, status: 1)
        item_2 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: merchanta.id)
        item_3 = Item.create!(name: "Scissors", description: "Snips like no other", unit_price: 5, merchant_id: merchanta.id)

        customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
        invoicea = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")

        ii_1 = InvoiceItem.create!(invoice_id: invoicea.id, item_id: item_1.id, quantity: 12, unit_price: 10, status: 2)
        ii_2 = InvoiceItem.create!(invoice_id: invoicea.id, item_id: item_2.id, quantity: 15, unit_price: 2, status: 1)

        expect(invoicea.total_revenue_with_discounts).to eq(117)
        expect(ii_1.best_qualifying_discount).to eq(bd_1)
        expect(ii_2.best_qualifying_discount).to eq(bd_2)
      end

      it "test case 4" do
        # Merchant A has two Bulk Discounts
        # Bulk Discount A is 20% off 10 items
        # Bulk Discount B is 15% off 15 items
        # Invoice A includes two of Merchant A’s items
        # Item A is ordered in a quantity of 12
        # Item B is ordered in a quantity of 15

        merchanta = Merchant.create!(name: 'Hair Care')
        bd_1 = merchanta.bulk_discounts.create!(name: '20 percent off 10 items', percentage_discount: 20, quantity_threshold: 10)
        bd_2 = merchanta.bulk_discounts.create!(name: '15 percent off 15 items', percentage_discount: 15, quantity_threshold: 15)

        item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: merchanta.id, status: 1)
        item_2 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: merchanta.id)
        item_3 = Item.create!(name: "Scissors", description: "Snips like no other", unit_price: 5, merchant_id: merchanta.id)

        customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
        invoicea = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")

        ii_1 = InvoiceItem.create!(invoice_id: invoicea.id, item_id: item_1.id, quantity: 12, unit_price: 1, status: 2)
        ii_2 = InvoiceItem.create!(invoice_id: invoicea.id, item_id: item_2.id, quantity: 15, unit_price: 2, status: 1)

        expect(invoicea.total_revenue_with_discounts).to eq(33.6)
        expect(ii_1.best_qualifying_discount).to eq(bd_1)
        expect(ii_2.best_qualifying_discount).to eq(bd_1)
      end

      it "test case 5" do
        # Merchant A has two Bulk Discounts
        # Bulk Discount A is 20% off 10 items
        # Bulk Discount B is 30% off 15 items
        # Merchant B has no Bulk Discounts
        # Invoice A includes two of Merchant A’s items
        # Item A1 is ordered in a quantity of 12
        # Item A2 is ordered in a quantity of 15
        # Invoice A also includes one of Merchant B’s items
        # Item B is ordered in a quantity of 15

        merchanta = Merchant.create!(name: 'Hair Care')
        merchantb = Merchant.create!(name: 'Hair Care')

        bd_1 = merchanta.bulk_discounts.create!(name: '20 percent off 10 items', percentage_discount: 20, quantity_threshold: 10)
        bd_2 = merchanta.bulk_discounts.create!(name: '30 percent off 15 items', percentage_discount: 30, quantity_threshold: 15)

        item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: merchanta.id, status: 1)
        item_2 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: merchanta.id)
        item_3 = Item.create!(name: "Scissors", description: "Snips like no other", unit_price: 5, merchant_id: merchanta.id)

        merchantb_item = Item.create!(name: "Gloves", description: "Grips like no other", unit_price: 5, merchant_id: merchantb.id)

        customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
        invoicea = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")

        ii_1 = InvoiceItem.create!(invoice_id: invoicea.id, item_id: item_1.id, quantity: 12, unit_price: 1, status: 2)
        ii_2 = InvoiceItem.create!(invoice_id: invoicea.id, item_id: item_2.id, quantity: 15, unit_price: 2, status: 1)
        ii_3 = InvoiceItem.create!(invoice_id: invoicea.id, item_id: merchantb_item.id, quantity: 15, unit_price: 2, status: 1)

        expect(invoicea.total_revenue_with_discounts).to eq(60.6)
        expect(ii_1.best_qualifying_discount).to eq(bd_1)
        expect(ii_2.best_qualifying_discount).to eq(bd_2)
        expect(ii_3.best_qualifying_discount).to eq(nil)
      end
    end
  end
end
