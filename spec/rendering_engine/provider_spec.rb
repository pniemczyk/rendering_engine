require "spec_helper"

describe RenderingEngine::Provider do
  let(:base_path)     { 'root/contract/files' }
  let(:relative_path) { 'login/form.html' }
  let(:file_path)     { File.join(base_path, relative_path) }
  let(:content)       { double('ContentObject') }
  let(:data)          { double('data') }
  let(:custom_helper) { double('custom_helper') }
  let(:opts)          {{ data: data, custom_helper: custom_helper }}
  subject { described_class.new(base_path) }

  it '#get' do
    RenderingEngine::Content.should_receive(:new)
      .with(file_path, opts)
      .and_return(content)
    subject.get(relative_path, opts).should be content
  end
end
