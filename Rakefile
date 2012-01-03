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

  def link_zsh_themes
    oh_my_zsh_themes = File.join(home, '.oh-my-zsh', 'themes')
    if File.directory?(oh_my_zsh_themes)
      Dir.glob(File.dirname(__FILE__) + '/shell/zsh/themes/*').each do |file|
        symbolic_link(file, File.join(oh_my_zsh_themes, File.basename(file)))
      end
    end
  end

  desc "Create symlinks in #{home}"
  task :setup do
    link_dotfiles
    link_zsh_themes
    Rake::Task["dotfiles:vim:setup"].invoke
  end

  namespace :vim do

    desc "Setup vim plugins"
    task :setup => [:update,:compile] do
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
    end

  end
end

