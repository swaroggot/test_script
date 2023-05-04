# frozen_string_literal: true

require 'pry'
require_relative 'valid_passwords_from_file_counter'

file_path = ARGV[0]

if file_path
  puts ValidPasswordsFromFileCounter.new(file_path).call
else
  puts 'Write file path please!'
end
