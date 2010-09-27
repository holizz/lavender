def setup_sample_project
  files = {
    'config.yml' => <<END,
---
defaults:
  layout: main
END
    'pages/index.html.yml' => <<END,
---
layout: null
processor: raw
---
<audio src="girlfriendboy.wav"></audio>
END
  }

  FakeFS do
    files.each_pair do |name,content|
      dir = File.dirname(name)
      FileUtils.mkdir_p dir unless File.directory? dir
      File.open(name,'w+') do |f|
        f.write content
      end
    end
  end
end
