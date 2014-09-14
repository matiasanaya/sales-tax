RSpec.shared_examples 'a accountable' do
  subject { object }
  describe 'the public interface' do
    it { is_expected.to respond_to :unit_sales_tax, :to_hash }
  end

  describe '#to_hash' do
    subject { object.to_hash }
    it { is_expected.to include :unit_sales_tax, :total_unit_price }
  end
end
