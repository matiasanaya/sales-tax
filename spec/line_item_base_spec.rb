require_relative '../lib/sales_tax/line_item/base'
require_relative 'shared_examples_for_line_item_base'

RSpec.describe SalesTax::LineItem::Base do
  matching_h = {
    description: 'anything'
  }

  non_matching_h = {
    description: ''
  }

  it_behaves_like 'a line item', :other, matching_h, non_matching_h
end
