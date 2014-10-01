require 'spec_helper'

describe RenderingEngine::Content do
  let(:file_repo)      { double('RenderingEngine::FileRepo') }
  let(:test_base_path) { nil }
  let(:relative_path)  { 'login' }
  let(:file_path)      { "#{relative_path}/form.html" }
  let(:content)        { double('ContentObject') }
  let(:content_data)   { nil }
  let(:custom_helper)  { nil }
  let(:opts) do
    {
      base_folder_path: test_base_path,
      data: content_data,
      custom_helper: custom_helper
    }
  end

  subject { described_class.new(file_repo, file_path, opts) }

  context '#source' do

    before(:each) { expect(subject).to receive(:kind).and_return(kind) }

    context 'when file is not found' do
      let(:kind) { :unknown }

      it 'returns empty string' do
        expect(subject.source).to eq ''
      end
    end

    context 'when orginal file is found' do
      let(:kind)   { :orginal }
      let(:source) { 'file_source' }
      before { expect(file_repo).to receive(:read).with(file_path).and_return(source) }

      it 'returns source of file' do
        expect(subject.source).to eq source
      end
    end

    context 'when orginal file is not found but template file is found' do
      let(:kind)            { :template }
      let(:source)          { 'calc 1+1=<%= 1+1 %>' }
      let(:rendered_source) { 'calc 1+1=2' }
      let(:erb_file_path)   { "#{file_path}.erb" }
      before do
        expect(file_repo).to receive(:file_dirname)
                             .with(file_path)
                             .and_return(relative_path)
        expect(file_repo).to receive(:read)
                             .with(erb_file_path)
                             .and_return(source)
      end

      it 'returns rendered source' do
        expect(subject.source).to eq rendered_source
      end

      context 'erb result' do
        let(:erb_instance) { double('erb_instance') }
        before do
          expect(ERB).to receive(:new).with(source).and_return(erb_instance)
          expect(subject).to receive(:helper).with(relative_path, content_data)
            .and_return(double)
          expect(erb_instance).to receive(:result).with(an_instance_of(Binding))
            .and_return(rendered_source)
        end
        it 'receives helper' do
          expect(subject.source).to eq rendered_source
        end
      end
    end
  end

  context '#kind' do
    context 'when orginal_file_present' do
      before { expect(subject).to receive(:orginal_file_present?).and_return(true) }
      it 'returns :orginal' do
        expect(subject.kind).to eq :orginal
      end
    end

    context 'when orginal_file_present is missing but template file is present' do

      before do
        expect(subject).to receive(:orginal_file_present?).and_return(false)
        expect(subject).to receive(:file_as_erb_present?).and_return(true)
      end

      it 'returns :template' do
        expect(subject.kind).to eq :template
      end
    end

    context 'when orginal and template file is missing' do

      before do
        expect(subject).to receive(:orginal_file_present?).and_return(false)
        expect(subject).to receive(:file_as_erb_present?).and_return(false)
      end

      it 'returns :unknown' do
        expect(subject.kind).to eq :unknown
      end
    end
  end

  %w{template orginal unknown}.each do |method_name|
    it "##{method_name}? returns true when content kind is :#{method_name}" do
      expect(subject).to receive(:kind).and_return(method_name.to_sym)
      expect(subject.public_send("#{method_name}?")).to eq true
    end

    it "##{method_name}? returns false when content kind is not :#{method_name}" do
      expect(subject).to receive(:kind).and_return(:bad)
      expect(subject.public_send("#{method_name}?")).to eq false
    end
  end

  it '#base_folder_path' do
    expect(file_repo).to receive(:file_dirname)
                         .with(file_path)
                         .and_return(relative_path)
    expect(subject.base_folder_path).to eq(relative_path)
  end
end
