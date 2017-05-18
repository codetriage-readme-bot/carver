describe Carver::ClassExtractor do
  describe '#initialize' do
    subject { described_class.new(content, type) }
    let(:content) { File.read('spec/fixtures/sample_html.html') }
    let(:type) { :html }

    it 'initializes content, type and classes' do
      expect(subject.instance_variable_get(:@content)).to eq(content)
      expect(subject.instance_variable_get(:@type)).to eq(:html)
    end
  end

  describe '#scan' do
    subject { described_class.new(content, type).scan }

    context 'when type is html' do
      let(:type) { :html }
      let(:content) { File.read('spec/fixtures/sample_html.html') }

      it 'finds css classes within html' do
        expect(subject).to eq([
                                { element: 'div', id: nil, classes: ['container'] },
                                { element: 'div', id: 'super-row', classes: ['row'] },
                                { element: 'h2', id: nil, classes: %w(center bold) },
                                { element: 'p', id: 'awesome-paragraph', classes: ['italic'] }
                              ])
      end
    end

    context 'when type is js' do
      let(:type) { :js }
      let(:content) { File.read('spec/fixtures/sample_javascript.js') }

      it 'finds css classes within javascript' do
        expect(subject).to eq(%w(blue green visible-xs italic font-weight
                                 font-size background-color border-color padding-left))
      end
    end
  end
end
