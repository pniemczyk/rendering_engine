require "spec_helper"

describe RenderingEngine::ContentHelpers do
  let(:base_path)          { 'root/path' }
  let(:file_relative_path) { 'login.haml' }
  let(:file_path)          { File.join(base_path, file_relative_path) }
  let(:content)            { double('content_object', source: source) }
  let(:source)             { 'file_source' }
  subject { described_class.new(base_path: base_path) }

  it '#render' do
    RenderingEngine::Content.should_receive(:new)
      .with(file_path)
      .and_return(content)

    subject.render(file_relative_path).should eq source
  end
end
