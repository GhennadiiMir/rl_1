require_relative './sortable_list'
require_relative './list_parser'

class PeopleController
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def normalize
    list = SortableList.new
    params.each do |format, text|
      next unless format.to_s.end_with?("_format")

      list.add ListParser.new(format).parse(text)
    end
    list.present(sorted_by: :first_name, fields: [:first_name, :city, birthdate: "%-m/%-d/%Y"])
  end

  private

  attr_reader :params
end
