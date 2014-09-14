require_relative '../lib/sales_tax/receipt'

RSpec.describe SalesTax::Receipt do
  ItemDouble = Struct.new(:hash) do
    def to_hash
      hash
    end
  end

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

    context 'with item 0' do
      let!(:item_0) {
        _item = ItemDouble.new(
          quantity: 1,
          description: 'a item',
          unit_price: BigDecimal('11.1'),
          unit_sales_tax: BigDecimal('0'),
          total_unit_price: BigDecimal('11.1')
        )
        receipt.add_item(_item)
        _item
      }

      it 'formats numbers to two decimal places' do
        expect(subject).to match /11\.10\n\n.+0\.00/
      end

      it 'matches exactly' do
        expect(subject).to match <<-END.gsub(/^\s+\|/, '')
          |1, a item, 11.10
          |
          |Sales Taxes: 0.00
          |Total: 11.10
        END
      end
    end

    context 'with two items' do
      let!(:item_1) {
        _item = ItemDouble.new(
          quantity: 1,
          description: 'a description',
          unit_price: BigDecimal('12.49'),
          unit_sales_tax: BigDecimal('0.65'),
          total_unit_price: BigDecimal('13.14')
        )
        receipt.add_item(_item)
        _item
      }
      let!(:item_2) {
        _item = ItemDouble.new(
          quantity: 1,
          description: 'another description',
          unit_price: BigDecimal('18.99'),
          unit_sales_tax: BigDecimal('1.9'),
          total_unit_price: BigDecimal('20.89')
        )
        receipt.add_item(_item)
        _item
      }

      it 'prints every item' do
        expect(subject).to match /a description.+\n.+another description/
      end

      it 'prints taxed prices' do
        expect(subject).to match /13\.14\n.+20\.89/
      end

      it 'prints a sales taxes total' do
        expect(subject).to match /2\.55/
      end

      it 'prints a total' do
        expect(subject).to match /34\.03/
      end

      it 'matches exactly' do
        expect(subject).to match <<-END.gsub(/^\s+\|/, '')
          |1, a description, 13.14
          |1, another description, 20.89
          |
          |Sales Taxes: 2.55
          |Total: 34.03
        END
      end
    end
  end
end
