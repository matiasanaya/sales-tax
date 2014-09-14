require_relative '../lib/sales_tax/line_item/medicine'
require_relative 'shared_examples_for_line_item_base'

RSpec.describe SalesTax::LineItem::Medicine do
  let(:object_klass) { SalesTax::LineItem::Medicine }
  let(:category) { :medicine }
  it_behaves_like 'a line item'
end
