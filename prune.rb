require "fileutils" 

all = Dir["debs/*.deb"].map { |f| File.realpath(f) }.uniq
latest = Dir["debs/*-latest.deb"].map { |f| File.realpath(f) }.uniq
(all - latest).each do |old|
  $stderr.puts "Removing #{old}"
  FileUtils.rm old
end

Dir["*/tmp/*"].each do |path|
  $stderr.puts "Removing #{path}"
  FileUtils.rm_rf path
end
