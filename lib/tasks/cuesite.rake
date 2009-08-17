namespace :cuesite do
  desc "Load all cues from a give directory into the database"
  task :load_from_dir => :environment do
    Dir.glob(File.join(ENV['dir'], "*.cue")).each do |d|
      begin
        cue = Cuesheet.load_from_file(d)
        p "#{d} successfully loaded!"
      rescue
        p "#{d} FAILED to load."
      end
    end
  end
end
