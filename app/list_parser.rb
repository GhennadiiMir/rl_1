require 'date'
require_relative 'city_normalizer'

class ListParser
  include CityNormalizer

  attr_reader :separator, :columns

  def initialize(format)
    @list = []
    @separator = separators[format]
    raise "Error: Wrong format: #{format}" if separator.nil?
  end

  def parse(text)
    lines = text.lines
    @columns = lines.first.chomp.split(separator).map{ |field| field.to_sym}

    lines[1..-1].map do |line|
      parse_line(line.chomp)
    end
  end

  private

  def parse_line(line)
    person = {}
    line.split(separator).each_with_index do |field, index|
      data = case columns[index]
             when :birthdate
               Date.parse(field)
             when :city
               normalize(field)
             else
               field
             end
      person[columns[index]] = data
    end
    person
  end

  def separators
    {
      dollar_format: ' $ ',
      percent_format: ' % '
    }
  end

end
