namespace :dotfiles do
  HOME = File.expand_path(ENV['HOME'])
  PWD = File.dirname(__FILE__)
  VIM = File.join(HOME, '.vim')

  files = %w{gitconfig vim vimrc gvimrc bashrc bash_profile dircolors bin autotest}
  desc "Create #{files.join(', ')} symlinks in #{HOME}"
  task :setup do
    path = File.dirname(__FILE__)
    files.each do |file|
      cmd = "ln -sfn #{path}/#{file} #{File.join(HOME, ".#{file}")}"
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
            if plugin_path =~ /snipmate-snippets$/
              `rake deploy_local`
            else
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
end

task :default => 'dotfiles:setup'
