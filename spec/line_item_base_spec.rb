require_relative '../lib/sales_tax/line_item/base'
require_relative 'shared_examples_for_line_item_base'

RSpec.describe SalesTax::LineItem::Base do
  let(:object_klass) { SalesTax::LineItem::Base }
  let(:category) { :other }
  it_behaves_like 'a line item', SalesTax::LineItem::Base
end
