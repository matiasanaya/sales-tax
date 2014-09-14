RSpec.shared_examples 'a line item' do
  let(:object) {
    object_klass.new(
      quantity: 1,
      description: description,
      unit_price: 1
    )
  }
  context 'with a standard description' do
    let(:description) { 'a description' }
    describe '#category' do
      it "returns the correct symbol" do
        expect(object.send(:category)).to eq category
      end
    end
    describe '#to_hash' do

      let(:expected_hash) {
        {
          quantity: 1,
          description: 'a description'
        }
      }
      subject { object.to_hash }

      it { is_expected.to be_instance_of Hash }
      it { is_expected.to include expected_hash }
    end
  end

  describe '#imported?' do
    subject { object.send(:imported?) }
    context 'when imported' do
      let(:description) {'a imported description'}
      it { is_expected.to be }
    end
    context 'when local' do
      let(:description) {'a local description'}
      it { is_expected.to be_falsey }
    end
  end
end
