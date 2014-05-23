require "spec_helper"

describe RenderingEngine::Content do
  let(:test_base_path){ nil }
  let(:base_path)     { 'root/contract/files' }
  let(:relative_path) { 'login/form.html' }
  let(:file_path)     { File.join(base_path, relative_path) }
  let(:content)       { double('ContentObject') }
  let(:content_data)  { nil }
  let(:custom_helper) { nil }
  let(:opts) do
    {
      base_folder_path: test_base_path,
      data: content_data,
      custom_helper: custom_helper
    }
  end

  subject { described_class.new(file_path, opts) }

  context '#source' do

    before(:each) { subject.should_receive(:kind).and_return(kind) }

    context 'when file is not found' do
      let(:kind) { :unknown }

      it 'returns empty string' do
        subject.source.should eq ''
      end
    end

    context 'when orginal file is found' do
      let(:kind)   { :orginal }
      let(:source) { 'file_source' }
      before { File.should_receive(:read).with(file_path).and_return(source) }

      it 'returns source of file' do
        subject.source.should eq source
      end
    end

    context 'when orginal file is not found but template file is found' do
      let(:kind)            { :template }
      let(:source)          { 'calc 1+1=<%= 1+1 %>' }
      let(:rendered_source) { 'calc 1+1=2' }
      let(:erb_file_path)   { "#{file_path}.erb" }
      before { File.should_receive(:read).with(erb_file_path).and_return(source) }

      it 'returns rendered source' do
        subject.source.should eq rendered_source
      end

      context 'erb result' do
        let(:erb_instance)     { double('erb_instance') }
        let(:base_folder_path) { 'root/contract/files/login' }
        before do
          ERB.should_receive(:new).with(source).and_return(erb_instance)
          subject.should_receive(:helper).with(base_folder_path, content_data)
            .and_return(double)
          erb_instance.should_receive(:result).with(an_instance_of(Binding))
            .and_return(rendered_source)
        end
        it 'receives helper' do
          subject.source.should eq rendered_source
        end
      end
    end
  end

  context '#kind' do
    context 'when orginal_file_present' do
      before { subject.should_receive(:orginal_file_present?).and_return(true) }
      it 'returns :orginal' do
        subject.kind.should eq :orginal
      end
    end

    context 'when orginal_file_present is missing but template file is present' do

      before do
        subject.should_receive(:orginal_file_present?).and_return(false)
        subject.should_receive(:file_as_erb_present?).and_return(true)
      end

      it 'returns :template' do
        subject.kind.should eq :template
      end
    end

    context 'when orginal and template file is missing' do

      before do
        subject.should_receive(:orginal_file_present?).and_return(false)
        subject.should_receive(:file_as_erb_present?).and_return(false)
      end

      it 'returns :unknown' do
        subject.kind.should eq :unknown
      end
    end
  end

  %w{template orginal unknown}.each do |method_name|
    it "##{method_name}? returns true when content kind is :#{method_name}" do
      subject.should_receive(:kind).and_return(method_name.to_sym)
      subject.public_send("#{method_name}?").should be_true
    end

    it "##{method_name}? returns false when content kind is not :#{method_name}" do
      subject.should_receive(:kind).and_return(:bad)
      subject.public_send("#{method_name}?").should be_false
    end
  end

  it '#base_folder_path' do
    subject.should_receive(:file_path).and_return(relative_path)
    subject.base_folder_path.should eq 'login'
  end
end


