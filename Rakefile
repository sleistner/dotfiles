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

    desc "Init vim plugins as git submodules"
    task :init do
      `git submodule init`
    end

    desc "Update vim plugins"
    task :update => [:init] do
      `git submodule foreach 'cd #{File.dirname(__FILE__)}/$path && git co master && git pull origin master'`
    end

  end
end

