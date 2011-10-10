task :default => 'dotfiles:setup'

namespace :dotfiles do

  desc "Create symlinks in ~/"
  task :setup do
    home = File.expand_path(ENV['HOME'])
    Dir.glob(File.dirname(__FILE__) + '/linked/*').each do |file|
      cmd = "ln -sfn #{file} #{File.join(home, ".#{File.basename(file)}")}"
      puts "#{cmd} => #{system cmd}"
    end
    Rake::Task["dotfiles:vim:setup"].invoke
  end

  namespace :vim do

    desc "Setup vim plugins"
    task :setup => [:compile] do
      puts "Vim setup done."
    end

    desc "Compile vim plugins"
    task :compile => [:update] do
      Dir.chdir("#{File.dirname(__FILE__)}/linked/vim/bundle/command-T") do
        puts Dir.pwd
        system("rake make")
      end
    end

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

