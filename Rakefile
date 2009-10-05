desc "Create various symlinks in ~"
task :install do
  path = File.dirname(__FILE__)
  %w{vimrc bashrc bash_profile dircolors}.each do |file|
    cmd = "ln -sfn #{path}/#{file} ~/.#{file}"
    puts cmd, `#{cmd}`
  end
end

task :default => :install
