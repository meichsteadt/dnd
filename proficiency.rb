class Proficiency
    include Mongoid::Document
    file_name = `../5e-database/5e-SRD-Proficiencies.json`
    json = JSON.parse(File.open(file_name).read)

    json.each do |k,v|
      field k, type: v.class
    end
  end