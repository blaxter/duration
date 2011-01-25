require 'duration/version'

AUTHOR = 'Matthew Harris'  # can also be an array of Authors
EMAIL = "matt@matthewharris.org"
DESCRIPTION = %[
  Duration is a library for manipulating timespans.  It can give you readable
  output for a timespan as well as manipulate the timespan itself.  With this
  it is possible to make "countdowns" or "time passed since" type objects.
]
GEM_NAME = 'blaxter-duration' # what ppl will type to install your gem
RUBYFORGE_PROJECT = 'duration' # The unix name for your project
HOMEPATH = "http://#{RUBYFORGE_PROJECT}.rubyforge.org"
DOWNLOAD_PATH = "http://rubyforge.org/projects/#{RUBYFORGE_PROJECT}"

@config_file = "~/.rubyforge/user-config.yml"
@config = nil
RUBYFORGE_USERNAME = "kuja"
def rubyforge_username
  unless @config
    begin
      @config = YAML.load(File.read(File.expand_path(@config_file)))
    rescue
      puts <<-EOS
ERROR: No rubyforge config file found: #{@config_file}
Run 'rubyforge setup' to prepare your env for access to Rubyforge
 - See http://newgem.rubyforge.org/rubyforge.html for more details
      EOS
      exit
    end
  end
  RUBYFORGE_USERNAME.replace @config["username"]
end


REV = nil 
# UNCOMMENT IF REQUIRED: 
# REV = `svn info`.each {|line| if line =~ /^Revision:/ then k,v = line.split(': '); break v.chomp; else next; end} rescue nil
VERS = Duration::VERSION::STRING + (REV ? ".#{REV}" : "")
RDOC_OPTS = ['--quiet', '--title', 'duration documentation',
    "--opname", "index.html",
    "--line-numbers", 
    "--main", "README.txt",
    '--exclude', 'index.txt',
    "--inline-source"]

class Hoe
  def extra_deps 
    @extra_deps.reject! { |x| Array(x).first == 'hoe' } 
    @extra_deps
  end 
end

# Generate all the Rake tasks
# Run 'rake -T' to see list of generated tasks (from gem root directory)
hoe = Hoe.spec GEM_NAME do
  self.author = AUTHOR 
  self.description = DESCRIPTION
  self.email = EMAIL
  self.summary = DESCRIPTION
  self.url = HOMEPATH
  self.rubyforge_name = RUBYFORGE_PROJECT if RUBYFORGE_PROJECT
  self.test_globs = ["test/**/test_*.rb"]
  self.clean_globs |= ['**/.*.sw?', '*.gem', '.config', '**/.DS_Store']
  self.version = VERS

  # == Optional
  self.changes = self.paragraphs_of("History.txt", 0..1).join("\n\n")
end

CHANGES = hoe.paragraphs_of('History.txt', 0..1).join("\\n\\n")
PATH    = (RUBYFORGE_PROJECT == GEM_NAME) ? RUBYFORGE_PROJECT : "#{RUBYFORGE_PROJECT}/#{GEM_NAME}"
hoe.remote_rdoc_dir = File.join(PATH.gsub(/^#{RUBYFORGE_PROJECT}\/?/,''), 'rdoc')
hoe.rsync_args = '-av --delete --ignore-errors'
