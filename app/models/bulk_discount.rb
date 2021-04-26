class BulkDiscount < ApplicationRecord
  validates_presence_of :percentage_discount,
                        :quantity_threshold,
                        :merchant_id,
                        :name
  validates_numericality_of :percentage_discount,
                            :quantity_threshold,
                            :merchant_id
  belongs_to :merchant
  has_many :items, through: :merchants
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
end
