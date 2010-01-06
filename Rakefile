namespace :dotfiles do
  files = %w{vim vimrc bashrc bash_profile dircolors bin}
  desc "Create #{files.join(', ')} symlinks in #{File.expand_path('~')}"
  task :setup do
    path = File.dirname(__FILE__)
    files.each do |file|
      cmd = "ln -sfn #{path}/#{file} ~/.#{file}"
      puts "#{cmd} => #{system cmd}"
    end
  end

  namespace :vim do
    desc "Update tpope's vim plugins."
    task :update do
      with_vim_plugins do |plugin_path|
        `git pull origin master`
        with_plugin_files(plugin_path) do |plugin_file, target_file|
          FileUtils.mkdir_p(File.dirname(target_file))
          FileUtils.cp(plugin_file, target_file)
          puts "Copied #{plugin_file} to #{target_file}"
        end
      end
    end
    
    desc "Remove tpope's vim plugins."
    task :uninstall do
      with_vim_plugins do |plugin_path|
        with_plugin_files(plugin_path) do |plugin_file, target_file|
          FileUtils.remove_entry(target_file)
          puts "Removed #{target_file}"
        end
      end
    end
  end

  private

  def with_vim_plugins &block
    path = File.dirname(__FILE__)
    Dir["#{path}/vim-plugins/*"].each do |plugin_path|
      Dir.chdir plugin_path
      yield plugin_path
      Dir.chdir path
    end
  end

  def with_plugin_files(plugin_path, &block)
    Dir["#{plugin_path}/*/*"].each do |plugin_file|
      yield plugin_file, File.join(vimfiles, plugin_file.gsub(plugin_path, ''))
    end  
  end

  def vimfiles
    @vimfiles ||= File.expand_path('~/.vim')
  end
  
end

task :default => 'dotfiles:install'

