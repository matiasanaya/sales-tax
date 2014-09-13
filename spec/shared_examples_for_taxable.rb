RSpec.shared_examples 'a taxable' do
  describe 'the public interface' do
    subject { object }
    it { is_expected.to respond_to :unit_price, :imported?, :category }
  end

  describe '#unit_price' do
    subject { object.unit_price }
    it { is_expected.to be_instance_of BigDecimal }
  end

  describe '#imported?' do
    subject { object.imported? }
    it { is_expected.to_not be_nil }
  end

  describe '#category' do
    subject { object.category }
    it { is_expected.to_not be_nil }
  end
end