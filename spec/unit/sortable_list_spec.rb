require 'spec_helper'
require 'date'

RSpec.describe 'SortableList Test' do
  describe 'Returns list of lines composed from specified fields sorted by field' do
    let(:list) do
      portion1 = [
        {
          city: 'Los Angeles',
          birthdate: Date.new(1974, 4, 30),
          last_name: 'Nolan',
          first_name: 'Rhiannon'
        },
        {
          city: 'New York City',
          birthdate: Date.new(1962, 1, 5),
          last_name: 'Bruen',
          first_name: 'Rigoberto'
        }
      ]

      portion2 = [
        {
          first_name: 'Mckayla',
          city: 'Atlanta',
          birthdate: Date.new(1986, 5, 29)
        },
        {
          first_name: 'Elliot',
          city: 'New York City',
          birthdate: Date.new(1947, 5, 4)
        }
      ]

      SortableList.new(portion1 + portion2)
    end

    it 'returns list sorted by name for app test' do
      expect(list.present(sorted_by: :first_name, fields: [:first_name, :city, birthdate: '%-m/%-d/%Y'])).to eq [
        'Elliot, New York City, 5/4/1947',
        'Mckayla, Atlanta, 5/29/1986',
        'Rhiannon, Los Angeles, 4/30/1974',
        'Rigoberto, New York City, 1/5/1962',
      ]
    end

    it 'returns list sorted by date from latest in different format' do
      expect(list.present(sorted_by: { birthdate: :desc }, fields: [:first_name, :city, birthdate: "%b %-d '%y"])).to eq [
        "Mckayla, Atlanta, May 29 '86",
        "Rhiannon, Los Angeles, Apr 30 '74",
        "Rigoberto, New York City, Jan 5 '62",
        "Elliot, New York City, May 4 '47",
      ]
    end
  end
end
