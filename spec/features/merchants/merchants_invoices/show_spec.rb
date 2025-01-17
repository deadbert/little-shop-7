require 'rails_helper'

RSpec.describe "Merchant Invoices show", type: :feature do
  before(:each) do
    @merchant_1 = Merchant.create!(name: "Geoff's Goodies")
    @merchant_2 = Merchant.create!(name: "Bubba's Boutique")
    @discount_1 = @merchant_2.bulk_discounts.create!(threshold: 10, discount: 10)
    @chochky = @merchant_1.items.create!(name: "chochky", description: "Useless", unit_price: 50)
    @spinner = @merchant_2.items.create!(name: "Fidget Spinner", description: "Spins", unit_price: 1)
    @bouncer = @merchant_2.items.create!(name: "Bouncy Ball", description: "bounces", unit_price: 2)

    @cust_1 = Customer.create!(first_name: "Dave", last_name: "Beckam")
    @cust_2 = Customer.create!(first_name: "Becky", last_name: "Beckam")

    @invoice_1 = @cust_1.invoices.create!(status: 1)
    @invoice_item = InvoiceItem.create!(item_id: @spinner.id, invoice_id: @invoice_1.id, quantity: 20, status: 0, unit_price: 30)
    @invoice_2 = @cust_2.invoices.create!(status: 1)
    InvoiceItem.create!(item_id: @bouncer.id, invoice_id: @invoice_2.id, quantity: 30, status: 0, unit_price: 100)
  end

  describe "As a visitor" do
    describe "When I visit /merchants/:merchant_id/invoices/:invoice_id" do
      it "I see all of my items on the invoice including:
          -Item name
          -The quantity of the item ordered
          -the price the imem solf for
          -the invoice item status
          and I don't see invoices for any other merchants" do

        visit "/merchants/#{@merchant_2.id}/invoices/#{@invoice_1.id}"

        within(".invoice_info") do
          expect(page).to have_content("Item name: #{@spinner.name}")
          expect(page).to have_content("Quantity ordered: 20")
          expect(page).to have_content('Price: 30')
          expect(page).to have_select 'invoice_item_status', selected: "pending"

        end
      end
      
      it "I see the total revenue that the invoice will generate" do

        visit "/merchants/#{@merchant_2.id}/invoices/#{@invoice_1.id}"

        within(".revenue") do
          expect(page).to have_content("Total revenue: 6.0")
        end
      end

      it "and I see the total discounted revenue the invoice will generate" do

        visit "/merchants/#{@merchant_2.id}/invoices/#{@invoice_1.id}"

        within(".discounted_revenue") do
          expect(page).to have_content("Discounted revenue: 5.4")
        end
      end

      it "And I see a link to the discount that was applied to the invoice_item" do

        visit "/merchants/#{@merchant_2.id}/invoices/#{@invoice_1.id}"

        within('.invoice_info') do
          expect(page).to have_link "Applied Discount: #{@invoice_item.applied_discount}", href: "#{merchant_bulk_discount_path(@merchant_2, @discount_1)}"
        end
      end
    end
  end
end