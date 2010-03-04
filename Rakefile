namespace :dotfiles do
  PWD = File.dirname(__FILE__)
  VIM = File.expand_path('~/.vim')

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

    desc "Initialize vim plugins as git submodules"
    task :initialize do
      `git submodule update && git submodule init`
    end

    desc "Update vim plugins"
    task :update => ['vim:initialize'] do
      puts %x[git submodule foreach 'rake dotfiles:vim:update_plugin[`pwd`] -f #{__FILE__}']
    end

    task :update_plugin, :path do |t, args|
      if (plugin_path = args.path) =~ /vim-plugins/
        Dir.chdir(plugin_path) do
          if `git pull origin master`
            Dir.glob("#{plugin_path}/*/**/*").each do |file|
              next if File.directory?(file)
              target_file = File.join(VIM, file.gsub(plugin_path, ''))
              FileUtils.mkdir_p(File.dirname(target_file))
              FileUtils.cp_r(file, target_file, :remove_destination => true)
              puts "- #{file.sub(PWD, '')} => #{target_file}"
            end
          end
        end
      end
    end

  end
end

task :default => 'dotfiles:setup'
