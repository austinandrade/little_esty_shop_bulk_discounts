class BulkDiscountsController < ApplicationController
  before_action :find_merchant, only: [:index, :new, :show, :edit]
  before_action :next_3_holidays

  def index
    @bulk_discounts = @merchant.bulk_discounts
  end

  def show
    @bulk_discount = BulkDiscount.find(bulk_discount_params[:id])
  end

  def new
  end

  def create
    bulk_discount = BulkDiscount.new(bulk_discount_params)
    merchant = Merchant.find(bulk_discount_params[:merchant_id])

    if bulk_discount.save
      redirect_to merchant_bulk_discounts_path(merchant),
      notice: "bulk discount successfully created!"
    else
      redirect_to new_merchant_bulk_discount_path(merchant)
      flash[:alert] = "Error: #{error_message(bulk_discount.errors)}"
    end
  end

  def edit
    @bulk_discount = BulkDiscount.find(bulk_discount_params[:id])
  end

  def update
    bulk_discount = BulkDiscount.find(bulk_discount_params[:id])
    merchant = Merchant.find(bulk_discount_params[:merchant_id])

    if bulk_discount.update(bulk_discount_params)
      redirect_to merchant_bulk_discount_path(merchant, bulk_discount),
      notice: "successfully updated!"
    else
      redirect_to "/merchant/#{merchant.id}/bulk_discounts/#{bulk_discount.id}/edit",
      alert: "Error: #{error_message(bulk_discount.errors)}"
    end
  end

  def destroy
    merchant = Merchant.find(bulk_discount_params[:merchant_id])
    bulk_discount = BulkDiscount.find(bulk_discount_params[:id]).destroy

    redirect_to merchant_bulk_discounts_path(merchant)
  end

  private

  def bulk_discount_params
    params.permit(:id, :name, :percentage_discount, :quantity_threshold, :merchant_id)
  end

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  def next_3_holidays
    @holiday_service = HolidayService.new
  end
end
