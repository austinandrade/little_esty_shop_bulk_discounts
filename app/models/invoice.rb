class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :bulk_discounts, through: :merchants

  enum status: [:cancelled, :in_progress, :complete]

  def total_revenue_without_discounts
    invoice_items.sum("unit_price * quantity")
  end

  def discount_calculation
    invoice_items.joins(:bulk_discounts)
    .where('bulk_discounts.quantity_threshold <= invoice_items.quantity')
    .select('bulk_discounts.*, invoice_items.*, (invoice_items.quantity * invoice_items.unit_price * bulk_discounts.percentage_discount / 100) AS calculated_discount')
    .order(calculated_discount: :desc)
  end

  def total_revenue_with_discounts
    discounts = discount_calculation.uniq.sum(&:calculated_discount)
    (total_revenue_without_discounts - discounts).to_f.round(2)
  end
end
