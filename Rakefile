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
      path = File.dirname(__FILE__)
      Dir["#{path}/vim-plugins/*"].each do |plugin_path|
        Dir.chdir plugin_path
        `git pull origin master`
        vimfiles = File.expand_path('~/.vim')
        Dir["#{plugin_path}/*/*"].each do |file|
          target_file = File.join(vimfiles, file.gsub(plugin_path, ''))
          FileUtils.mkdir_p(File.dirname(target_file))
          FileUtils.cp(file, target_file)
          puts "Copied #{file} to #{target_file}"
        end
        Dir.chdir path
      end
    end
  end

end

task :default => 'dotfiles:install'
