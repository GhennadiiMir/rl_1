module CityNormalizer

  def normalize(city_name)
    canonicals[city_name] || city_name
  end

  def canonicals
    {
      'LA' => 'Los Angeles',
      'NYC' => 'New York City'
    }
  end

end
