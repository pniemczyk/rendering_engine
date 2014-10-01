require 'spec_helper'

describe RenderingEngine::FileRepo do
  let(:file_path) { 'some/file.erb' }
  let(:base_path) { '/root/home/user' }
  let(:full_path) { "#{base_path}/#{file_path}"}
  subject { described_class.new(base_path) }

  context '#exist?' do
    it 'returns true when file exist' do
      expect(File).to receive(:exist?).with(full_path).and_return(true)
      expect(subject.exist?(file_path)).to eq(true)
    end

    it 'returns false when file missing' do
      expect(File).to receive(:exist?).with(full_path).and_return(false)
      expect(subject.exist?(file_path)).to eq(false)
    end
  end

  context '#read' do
    let(:file_source) { 'test_source' }

    it 'get file source when file exist' do
      expect(File).to receive(:read).with(full_path).and_return(file_source)
      expect(subject.read(file_path)).to eq(file_source)
    end

    it 'raise error when file missing' do
      expect(File).to receive(:read).with(full_path).and_raise(Exception)
      expect {subject.read(file_path)}.to raise_error
    end
  end

  it '#file_dirname returns dirname from file_path' do
    expect(subject.file_dirname('/root/index.html')).to eq('/root')
  end
end
