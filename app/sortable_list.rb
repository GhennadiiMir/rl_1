require 'json'
require 'date'

class SortableList

  attr_reader :raw_list

  def initialize(list = [])
    @raw_list = list
  end

  def add(list)
    @raw_list += list
  end

  # examples:
  # present(sorted_by: :name, fields: [:name, :age])
  # we can provide format for date field
  # present(sorted_by: {name: :desc}, fields: [:name, birthdate: "%Y-%d-%m"])
  def present(sorted_by:, fields:)
    produce_lines(fields: fields, list: sort(sorted_by))
  end

  private

  def sort(rule)
    if rule.is_a?(Symbol)
      raw_list.sort_by{|el| el[rule]}
    elsif rule.is_a?(Hash)
      # assuming one key only
      key = rule.keys.first
      order = rule[key]

      list = raw_list.sort_by{|el| el[key]}

      (order == :desc) ? list.reverse : list
    else
      raise "Error: Wrong rule: '#{rule.to_json}'"
    end
  end

  def produce_lines(fields:, list:)
    list.map do |person|
      data = []
      fields.each do |field|
        case field.class.name
        when 'Symbol'
          data << person[field]
        when 'Hash' # format provided
          key = field.keys.first
          format = field[key]
          data << person[key].strftime(format)
        else
          raise "Error: Wrong field specification: '#{field.to_json}'"
        end
      end
      data.join(", ")
    end
  end
end
