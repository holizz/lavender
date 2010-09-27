def stub_files files
  files.each_pair do |name,content|
    dir = File.dirname(name)
    FileUtils.mkdir_p dir unless File.directory? dir
    File.open(name,'w+') do |f|
      f.write content
    end
  end
end

def stub_files_and_run files
  stub_files files
  c = Lavender::Static.new
  c.run
end
