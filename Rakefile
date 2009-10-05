namespace :dotfiles do
  files = %w{vim vimrc bashrc bash_profile dircolors bin}
  desc "Create #{files.join(', ')} symlinks in #{File.expand_path('~')}"
  task :install do
    path = File.dirname(__FILE__)
    files.each do |file|
      cmd = "ln -sfn #{path}/#{file} ~/.#{file}"
      puts "#{cmd} => #{system cmd}"
    end
  end

end


task :default => 'dotfiles:install'
