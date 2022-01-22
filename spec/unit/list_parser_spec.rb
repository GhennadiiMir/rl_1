require 'spec_helper'
require 'date'

RSpec.describe 'ListParser Test' do
  describe 'Parsing array of strings with header' do
    let(:people_by_dollar) { File.read('spec/fixtures/people_by_dollar.txt') }
    let(:people_by_percent) { File.read('spec/fixtures/people_by_percent.txt') }

    it 'parsing header' do
      parser = ListParser.new(:dollar_format)
      expect(parser.separator).to eq ' $ '
      result = parser.parse(people_by_dollar)
      expect(parser.columns).to eq [:city, :birthdate, :last_name, :first_name]

      parser = ListParser.new(:percent_format)
      expect(parser.separator).to eq ' % '
      parser.parse(people_by_percent)
      expect(parser.columns).to eq [:first_name, :city, :birthdate]
    end

    it 'converts date string into date' do
      parser = ListParser.new(:dollar_format)

      result = parser.parse(people_by_dollar)

      expect(result.first[:birthdate]).to be_a(Date)
    end

    it 'repalces abbreviation for city' do
      parser = ListParser.new(:dollar_format)

      result = parser.parse(people_by_dollar)

      expect(result.first[:city]).to eq 'Los Angeles'

      expect(result).to eq [
        {
          birthdate: Date.new(1974, 4, 30),
          city: 'Los Angeles',
          first_name: 'Rhiannon',
          last_name: 'Nolan'
        },
        {
          birthdate: Date.new(1962, 1, 5),
          city: 'New York City',
          first_name: 'Rigoberto',
          last_name: 'Bruen'
        }
      ]
    end
  end
end
