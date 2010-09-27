def setup_sample_project
  files = {
    'config.yml' => <<END,
---
defaults:
  layout: main
END
##########
# Pages
##########
    'pages/index.html.yml' => <<END,
---
layout: null
processor: raw
---
<audio src="girlfriendboy.wav"></audio>
END
    'pages/hamster.html.yml' => <<END,
%p Text
END
    'pages/igonreme.txt' => <<END,
Ignore this!!!
END
    'pages/refectory.html.yml' => <<END,
---
layout: clarissa/explains
processor: raw
---
Hello there
END
##########
# Layouts
##########
    'layouts/main.erb' => <<END,
<body>
  <%= yield %>
</body>
END
    'layouts/clarissa/explains.erb' => <<END,
<noscript>
  <%= yield %>
</noscript>
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
