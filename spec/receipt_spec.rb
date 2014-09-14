require_relative '../lib/sales_tax/receipt'

RSpec.describe SalesTax::Receipt do
  let(:receipt) { SalesTax::Receipt.new }

  describe 'the public interface' do
    subject{ receipt }
    it { is_expected.to respond_to :add_item, :print }
  end

  describe '#add_item' do
    it 'adds item to items list' do
      item = Object.new
      receipt.add_item(item)
      expect(receipt.instance_variable_get(:@items)).to include(item)
    end
  end

  describe '#print' do
    subject { receipt.print }
    it { is_expected.to be_instance_of String }
  end
end
