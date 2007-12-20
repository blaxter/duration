$:.unshift './lib'
require 'duration/version'

$svnedit = 'mate --wait'
$svnuser = 'kuja'
$package = 'duration'
$version = Duration::VERSION
$release = "#{$package}-#{$version}"
$copytag = [
  "svn+ssh://#{$svnuser}@rubyforge.org/var/svn/#{$package}/trunk",
  "svn+ssh://#{$svnuser}@rubyforge.org/var/svn/#{$package}/tags/#{$release}"
]

desc "release #{$release}"
task :release do
  system 'gem', 'build', "#{$package}.gemspec"
  system 'svn', 'ci', '--editor-cmd', $svnedit
  system 'svn', 'copy', '--editor-cmd', $svnedit, *$copytag
end