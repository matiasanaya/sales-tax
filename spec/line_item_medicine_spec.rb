require_relative '../lib/sales_tax/line_item/medicine'
require_relative 'shared_examples_for_line_item_base'

RSpec.describe SalesTax::LineItem::Medicine do
  matching_h = {
    description: 'epic headache relief'
  }

  non_matching_h = {
    description: 'not medical stuff'
  }

  it_behaves_like 'a line item', :medicine, matching_h, non_matching_h
end
