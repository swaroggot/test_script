# frozen_string_literal: true

# ValidPasswordsFromFileCounter returns valid passwords count from file if file exists.
class ValidPasswordsFromFileCounter
  def initialize(file_path)
    @file_path = file_path
  end

  attr_reader :file_path

  def call
    return file_path_not_found_alert unless File.exist?(file_path)
    return invalid_file_line_format_alert unless read_passwords

    valid_passwords_count = read_passwords.count { |symbol, range, password| valid_password?(symbol, range, password) }
    "Valid passwords count from #{file_path}: #{valid_passwords_count}"
  end

  private

  def file_path_not_found_alert
    'File not fount or file path is incorrect!'
  end

  def read_passwords
    File.readlines(file_path).map do |line|
      return nil unless valid_line?(line)

      symbol, range, password = line.split
      [symbol, range.split('-').map(&:to_i), password]
    end
  end

  def valid_line?(line)
    !!line.match(/^[a-z]{1}\s\d+-\d+:\s[a-z]+$/)
  end

  def invalid_file_line_format_alert
    <<~HEREDOC
      File has invalid line. Each line element must be:
      1) First element of line must be a single letter, for example: a, b, c, etc...
      2) Second element of line must be a number range, for example: 1-5:, 3-4:, etc...
      3) Last element of line must be a password, for example: abcdfs, dfrsgrewq, etc...
    HEREDOC
  end

  def valid_password?(symbol, range, password)
    password.count(symbol).between?(range[0], range[1])
  end
end
