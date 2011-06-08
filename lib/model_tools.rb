module ModelTools
  def unique_from_csv(csv)
    values = []
    csv.split(",").each do |token|
      values.push(token) unless values.include?(token)
    end
    return values
  end
  
  def unique_from_array_of_csvs(current_array)
    values = []
    current_array.each do |csv|
      csv.split(",").each do |token|
        values.push(token) unless values.include?(token)
      end
    end
    return values
  end
  
  def unique_like_to_json(search_term)
    results = self.like(search_term).collect {|token| token.name}
    sorted = self.unique_from_array_of_csvs(results)
    json = (sorted.collect {|token| {:name => token}}).to_json
    return json
  end
end

module InstanceModules
  def before_save
    return self.name = self.class.unique_from_csv(self.name).join(",")
  end
end