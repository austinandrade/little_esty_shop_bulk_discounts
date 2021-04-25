class BulkDiscount < ApplicationRecord
  validates_presence_of :percentage_discount,
                        :quantity_threshold,
                        :merchant_id,
                        :name

  belongs_to :merchant
end
