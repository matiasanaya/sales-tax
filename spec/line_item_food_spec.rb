require_relative '../lib/sales_tax/line_item/food'
require_relative 'shared_examples_for_line_item_base'

RSpec.describe SalesTax::LineItem::Food do
  matching_h = {
    description: 'some chocolate fun'
  }

  non_matching_h = {
    description: 'non food product'
  }

  it_behaves_like 'a line item', :food, matching_h, non_matching_h
end
