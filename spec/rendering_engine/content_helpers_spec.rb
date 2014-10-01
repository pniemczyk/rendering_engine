require 'spec_helper'

describe RenderingEngine::ContentHelpers do
  let(:file_repo)          { double('RenderingEngine::FileRepo') }
  let(:base_path)          { 'root/path' }
  let(:file_relative_path) { 'login.haml' }
  let(:file_path)          { File.join(base_path, file_relative_path) }
  let(:content)            { double('content_object', source: source) }
  let(:source)             { 'file_source' }
  let(:content_data)       { { name: 'pawel' } }
  subject { described_class.new(file_repo, base_path: base_path, data: content_data) }

  it '#render' do
    expect(RenderingEngine::Content).to receive(:new)
                                        .with(file_repo,
                                              file_path,
                                              data: content_data)
                                        .and_return(content)

    expect(subject.render(file_relative_path)).to eq(source)
  end
end
