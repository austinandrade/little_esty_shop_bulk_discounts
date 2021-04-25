class BulkDiscount < ApplicationRecord
  validates_presence_of :percentage_discount,
                        :quantity_threshold,
                        :merchant_id,
                        :name
  validates_numericality_of :percentage_discount,
                            :quantity_threshold,
                            :merchant_id
  belongs_to :merchant
end
