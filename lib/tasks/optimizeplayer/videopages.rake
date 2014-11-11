namespace :optimizeplayer do
  namespace :videopages do
    desc "Remove widgets of all videopages for adding default videobox widgets first after"
    task :remove_widgets => :environment do
      videopages = Videopage.all
      unless videopages.blank?
        videopages.each do |videopage|
          videopage.widgets = nil
          videopage.save
        end
      end
    end
  end
end
