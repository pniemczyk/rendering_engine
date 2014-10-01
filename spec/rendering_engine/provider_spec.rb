require 'spec_helper'

describe RenderingEngine::Provider do
  let(:file_repo)     { double('RenderingEngine::FileRepo') }
  let(:file_path)     { 'login/form.html' }
  let(:content)       { double('ContentObject') }
  let(:data)          { double('data') }
  let(:custom_helper) { double('custom_helper') }
  let(:opts)          { { data: data, custom_helper: custom_helper } }
  subject { described_class.new(file_repo) }

  it '#get' do
    expect(RenderingEngine::Content).to receive(:new)
      .with(file_repo, file_path, opts)
      .and_return(content)
    expect(subject.get(file_path, opts)).to be content
  end
end
