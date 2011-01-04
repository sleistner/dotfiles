task :default => 'dotfiles:setup'

namespace :dotfiles do

  desc "Create symlinks in ~/"
  task :setup do
    home = File.expand_path(ENV['HOME'])
    Dir.glob(File.dirname(__FILE__) + '/linked/*').each do |file|
      cmd = "ln -sfn #{file} #{File.join(home, ".#{File.basename(file)}")}"
      puts "#{cmd} => #{system cmd}"
    end
  end

  namespace :vim do

    desc "Update vim plugins"
    task :update do
      `git submodule update`
    end

  end
end

