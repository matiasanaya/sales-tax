RSpec.shared_examples 'a line item' do |category, matching_h, non_matching_h|
  let(:object) {
    described_class.new(
      quantity: '1',
      description: description,
      unit_price: '1'
    )
  }

  describe 'the public interface' do
    it { expect(described_class).to respond_to :augment }
    let(:description) { '' }
    it { expect(object).to respond_to :to_hash }
  end

  describe '.augment' do
    context 'with a matching hash' do
      it 'returns a augmented hash' do
        expect(described_class.augment(matching_h)).to be_instance_of Hash
      end
    end
    context 'with non-matching hash' do
      it 'returns nil' do
        expect(described_class.augment(non_matching_h)).to be_nil
      end
    end
  end

  context 'with a standard description' do
    let(:description) { 'a description' }

    it_behaves_like 'a accountable'
    it_behaves_like 'a taxable'

    describe '#to_hash' do
      subject { object.to_hash }

      let(:expected_hash) {
        {
          quantity: '1',
          description: 'a description'
        }
      }

      it { is_expected.to be_instance_of Hash }
      it { is_expected.to include expected_hash }
    end

    describe '#category' do
      it 'returns the correct symbol' do
        expect(object.send(:category)).to eq category
      end
    end
  end

  describe '#imported?' do
    subject { object.send(:imported?) }

    context 'when imported' do
      let(:description) {'a imported description'}
      it { is_expected.to be }

      let(:description) {'imported description'}
      it { is_expected.to be }
    end

    context 'when local' do
      let(:description) {'a local description'}
      it { is_expected.to be_falsey }
    end
  end
end
