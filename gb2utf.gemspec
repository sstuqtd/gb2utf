require File.dirname(__FILE__) + '/spec/version.rb'

Gem::Specification.new do |s|
  s.name = 'gb2utf'
  s.author = 'xdanger'
  s.email = 'xdanger@xindong.com'
  s.license = 'MIT'
  s.version = Gb2utf::VERSION
  s.platform = 'ruby'
  s.summary = 'gb2utf is a utility for coverting all ASCII files in a direcotory to a new directory replace with GB18030 or UTF-8'
  s.description = 'ruby based converting utility'
  s.require_paths = ['bin', 'lib', 'spec']
  s.files = Dir['bin/*'] + Dir['lib/**/*.rb'] + Dir['spec/*.rb']
  s.files << Dir['[A-Z]*'] + Dir['test/**/*']
  s.files.reject! { |fn| fn.include? '.git' }
  s.add_dependency('iconv')
  
  s.bindir = 'bin'
  s.executables = ['gb2utf', 'utf2gb']
  s.extra_rdoc_files = ['README.md', 'LICENSE']
#  s.autorequire = 'rake'
  s.has_rdoc = true
  s.homepage = 'http://www.xd.com/'
  s.date = Time.now
end
