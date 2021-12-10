class LibLoader

  def self.load_class(j = 0)
    files = Dir["#{Rails.root}/5e-database/*"]

    files.each_with_index do |file, i|
      puts file
      class_name = file.split("/").last.match(/((?<=D\-).*(?=\.))/).to_s.singularize
      lower_class_name = class_name.downcase.gsub("-", "_")
      file_path = ".." + file.split("dnd-campaign-tool").last

      last_command = i + 1 == files.count ? nil : "rails runner LibLoader.load_class\(#{i + 1}\)"

      json = JSON.parse(File.open(file).read)

      fields = json.first.map do |k,v|
        "field :#{k}, type: #{v.class}"
      end.join("\n\t")



      spawn("printf 'class #{class_name.gsub("-", "")}
  include Mongoid::Document
  store_in collection: \"#{lower_class_name.pluralize.gsub('_', '-')}\"
  #{fields}
end' > ./lib/#{lower_class_name}.rb;")
    end
  end
end
