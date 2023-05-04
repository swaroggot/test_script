# frozen_string_literal: true

require 'pry'
require_relative '../valid_passwords_from_file_counter'

describe ValidPasswordsFromFileCounter do
  describe '.call' do
    subject { described_class.new(file_path).call }

    let(:file_path) { 'test.txt' }
    let(:enumerable) { Enumerable }

    context 'when file path is not exists' do
      before { allow(File).to receive(:exist?).with(file_path).and_return(false) }

      it { expect(subject).to eq('File not fount or file path is incorrect!') }
    end

    context 'when file path is exists' do
      before do
        allow(File).to receive(:exist?).with(file_path).and_return(true)
        allow(File).to receive(:readlines).with(file_path).and_return(enumerable)
        allow(enumerable).to receive(:map).and_return(lines)
      end

      context 'when all lines of file has valid format' do
        let(:lines) { [['a', [1, 5], 'abcdj'], ['z', [2, 4], 'asfalseiruqwo'], ['b', [3, 6], 'bhhkkbbjjjb']] }

        it { expect(subject).to eq("Valid passwords count from #{file_path}: 2") }
      end

      context 'when one of line from file has invalid format' do
        let(:lines) { nil }
        let(:invalid_file_line_format_alert) do
          <<~HEREDOC
            File has invalid line. Each line element must be:
            1) First element of line must be a single letter, for example: a, b, c, etc...
            2) Second element of line must be a number range, for example: 1-5:, 3-4:, etc...
            3) Last element of line must be a password, for example: abcdfs, dfrsgrewq, etc...
          HEREDOC
        end

        it { expect(subject).to eq(invalid_file_line_format_alert) }
      end
    end
  end
end
