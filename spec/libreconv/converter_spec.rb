# frozen_string_literal: true

RSpec.describe Libreconv::Converter do
  describe '.new' do
    it 'raises error if soffice command does not exists' do
      expect do
        described_class.new fixture_file, '/target', '/Whatever/soffice'
      end.to raise_error(IOError, /\bCan't find .*\bExecutable\b/i)
    end

    it 'raises error if source does not exists' do
      expect do
        described_class.new fixture_path('nonsense.txt'), '/target'
      end.to raise_error(IOError, /\bSource .* is neither a file\b/i)
    end
  end

  describe "timeout" do
    describe "#build_command" do
      it 'builds the command with a timeout' do
        # Just faking that the command is present here
        converter = described_class.new fixture_file, '/target', cmd = fixture_path('soffice'), nil, timeout_seconds: 42
        expect(converter.build_command("/tmp/tmp", "tmp/target")[0]).to end_with "timeout"
        expect(converter.build_command("/tmp/tmp", "tmp/target")[1]).to eq "42s"
      end


      it 'builds the command without a timeout' do
        # Just faking that the command is present here
        converter = described_class.new fixture_file, '/target', cmd = fixture_path('soffice'), nil
        expect(converter.build_command("/tmp/tmp", "tmp/target").first).to eq cmd
      end
    end
  end

  describe ':soffice_command' do
    it 'returns the user specified command path' do
      # Just faking that the command is present here
      converter = described_class.new fixture_file, '/target', cmd = fixture_path('soffice')
      expect(converter.soffice_command).to eq cmd
    end

    it 'returns the command found in path' do
      converter = described_class.new fixture_file, '/target'
      expect(File.exist?(converter.soffice_command)).to eq true # `which soffice`.strip
    end
  end
end
