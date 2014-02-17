namespace :maintenance do
  desc "Turn on maintenance mode"
  task :enable do
    on roles(:web) do
      require 'erb'

      reason = ENV['REASON']
      deadline = ENV['UNTIL']

      template = File.read(maintenance_template_path)
      result = ERB.new(template).result(binding)

      put result, "#{shared_path}/public/system/#{maintenance_basename}.html", :mode => 0644
    end
  end

  desc "Turn off maintenance mode"
  task :disable do
    on roles(:web) do
      run "rm -f #{shared_path}/public/system/#{maintenance_basename}.html"
    end
  end
end

namespace :load do
  task :defaults do
    set :maintenance_basename, "maintenance"
    set :maintenance_language, "en"
    set :maintenance_template_path, -> { File.expand_path("../maintenance.#{fetch(:maintenance_language)}.html.erb", __FILE__) }
  end
end
