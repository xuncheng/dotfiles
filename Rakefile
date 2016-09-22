class Installer
  def symlink(target, link)
    if File.symlink?(link)
      unlink(link)
    elsif File.exist?(link)
      puts "ERROR: File exists: #{link}"
      exit 1
    end
    puts "Symlinking #{link} => #{target}"
    File.symlink(target, link)
  end

  def delete_symlink(link)
    unlink(link) if File.symlink?(link)
  end

  def unlink(link)
    if File.exist?(link)
      descriptor = File.symlink?(link) ? "symlink" : "file"
      puts "Deleting #{descriptor} #{link}"
      File.unlink(link)
    end
  end

  def merge(source_file, target_file)
    %x(cat #{source_file} >> #{target_file})
    puts "Merging #{source_file} => #{target_file}"
  end
end

def pwd; File.dirname(__FILE__); end
def target_path(file)
  File.join(ENV["HOME"], ".#{file}")
end

files = File.new(File.join(pwd, "MANIFEST"), "r").read.split("\n")

desc "Install all dotfiles"
task :install do
  files.each do |file|
    Installer.new.symlink(File.join(pwd, file), target_path(file))
  end
  Installer.new.merge(File.join(pwd, 'zshrc'), target_path('zshrc'))
end

desc "Remove all dotfiles"
task :uninstall do
  files.each do |file|
    Installer.new.unlink(target_path(file))
  end
end
