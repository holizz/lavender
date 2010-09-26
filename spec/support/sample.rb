def setup_sample_project
  files = {
    'config.yml' => <<END,
---
defaults:
  layout: main
END
  }

  FakeFS do
    files.each_pair do |name,content|
      File.open(name,'w+') do |f|
        f.write content
      end
    end
  end
end
