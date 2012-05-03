task :default => 'dotfiles:setup'

namespace :dotfiles do

  def home
    @home ||= File.expand_path(ENV['HOME'])
  end

  def symbolic_link(src, target)
    cmd = "ln -sfn #{src} #{target}"
    puts "#{cmd} => #{system(cmd)}"
  end

  def link_dotfiles
    Dir.glob(File.dirname(__FILE__) + '/linked/*').each do |file|
      symbolic_link(file, File.join(home, ".#{File.basename(file)}"))
    end
  end

  desc "Setup home symlinks and vim plugins."
  task :setup => [:symlink, "dotfiles:vim:setup"] do
  end

  desc "Create symlinks in #{home}"
  task :symlink do
    link_dotfiles
  end

  namespace :vim do

    desc "Setup vim plugins"
    task :setup => [:update, :compile] do
      puts "Vim setup done."
    end

    desc "Compile vim plugins"
    task :compile do
      Dir.chdir("#{File.dirname(__FILE__)}/linked/vim/bundle/command-T") do
        system("rake make")
      end
    end

    desc "Init vim plugins as git submodules"
    task :init do
      `git submodule init`
    end

    desc "Update vim plugins"
    task :update => [:init] do
      `git submodule update`
      `git submodule foreach 'cd #{File.dirname(__FILE__)}/$path && git co master && git pull origin master'`
    end

  end
end

