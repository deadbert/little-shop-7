class BulkDiscountsController < ApplicationController
  def index
    @discounts = BulkDiscount.all
    @merchant = Merchant.find(params[:merchant_id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    @merchant.bulk_discounts.create!(discount_params)
    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  def destroy
    @merchant = Merchant.find(params[:merchant_id])
    BulkDiscount.find(params[:id]).delete
    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.find(params[:bulk_discount_id])
  end

  def update
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.find(params[:id])
    @bulk_discount.update!(discount_params_update)
    redirect_to "/merchants/#{@merchant.id}/bulk_discounts/#{@bulk_discount.id}"
  end

  private

  def discount_params_update
    params.require(:bulk_discount).permit(:discount, :threshold)
  end
  
  def discount_params
    params.permit(:discount, :threshold)
  end
end