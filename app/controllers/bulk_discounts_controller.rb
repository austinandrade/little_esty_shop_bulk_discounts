class BulkDiscountsController < ApplicationController
  before_action :find_merchant, only: [:index]
  before_action :next_3_holidays

  def index
    @bulk_discounts = @merchant.bulk_discounts
  end

  def show
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  private

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  def next_3_holidays
    @holiday_service = HolidayService.new
  end
end
