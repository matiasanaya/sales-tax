require_relative '../lib/sales_tax/line_item/book'
require_relative 'shared_examples_for_line_item_base'

RSpec.describe SalesTax::LineItem::Book do
  matching_h = {
    description: 'some books'
  }

  non_matching_h = {
    description: 'this is not readable'
  }

  it_behaves_like 'a line item', :book, matching_h, non_matching_h
end
