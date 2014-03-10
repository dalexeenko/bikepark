desc "Fetch bicycle parking data and store it in the database"
task :fetch_bikeracks => :environment do
    Bikerack.populate
end
