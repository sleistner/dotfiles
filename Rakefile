namespace :dotfiles do
  files = %w{gitconfig vim vimrc bashrc bash_profile dircolors bin}
  desc "Create #{files.join(', ')} symlinks in #{File.expand_path('~')}"
  task :setup do
    path = File.dirname(__FILE__)
    files.each do |file|
      cmd = "ln -sfn #{path}/#{file} ~/.#{file}"
      puts "#{cmd} => #{system cmd}"
    end
  end

  namespace :vim do
    desc "Initializes vim plugins as git submodules"
    task :initialize do
      `git submodule update && git submodule init`
    end

    desc "Update tpope's vim plugins."
    task :update => ['vim:initialize'] do
      vimfiles = File.expand_path('~/.vim')
      Dir.glob("#{File.dirname(__FILE__)}/vim-plugins/*").each do |plugin_path|
        Dir.chdir(plugin_path) do
          if `git pull origin master`
            Dir.glob("#{plugin_path}/*/*").each do |file|
              target_file = File.join(vimfiles, file.gsub(plugin_path, ''))
              FileUtils.mkdir_p(File.dirname(target_file))
              FileUtils.cp(file, target_file)
              puts "Copied #{file} to #{target_file}"
            end
          end
        end
      end
    end
  end

end

task :default => 'dotfiles:install'
