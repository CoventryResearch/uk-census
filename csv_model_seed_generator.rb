require 'csv'

csvfile = 'census_by_postcodedistrict.csv'
model = 'CensusCount'
data = CSV.read(csvfile, { :col_sep => ","})


generator_command = "rails generate active_record:model #{model} "
data[0].each_with_index do |label, i|
	label = label.downcase
	if i == 0
		generator_command = generator_command + label+':string '
	else
		generator_command = generator_command + label+':integer '
	end
end
puts '###### Generator command ########'
puts generator_command
puts ''

seed_command = "#{model}.create({"
data[0].each_with_index do |label, i|
	seed_command = seed_command + label.downcase + ": row[#{i}], "
end
seed_command = seed_command[0...-2] # Remove last ', '
seed_command = seed_command + "})"


puts '###### Seeder commands ########'
puts "parsed_file = CSV.read(\"public/data/#{csvfile}\", { :col_sep => \",\", :headers=>:first_row})"
puts 'parsed_file.each do |row|'
puts '   '+seed_command
puts 'end'