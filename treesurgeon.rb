#!/usr/bin/env ruby -w

require 'optparse'
options = {}

optparse = OptionParser.new do|opts|
  opts.banner = <<-BANNER
    Usage: TODO.rb [options] file1 file2 ...
  BANNER

  options[:verbose] = false
  opts.on( '-v', '--verbose', 'Output more information' ) do
    options[:verbose] = true
  end

  options[:file] = false
  opts.on( '-f', '--file FILE', 'Stores output to FILE' ) do |file|
    options[:file] = file
  end

  options[:quick] = false
  opts.on( '-q', '--quick', 'Perform the task quickly' ) do
    options[:quick] = true
  end

  options[:logfile] = nil
  opts.on( '-l', '--logfile FILE', 'Write log to FILE' ) do |file|
    options[:logfile] = file
  end

  opts.on( '-h', '--help', 'Display this screen' ) do
    puts opts
    exit
  end
end

# Parse the command-line. Remember there are two forms
# of the parse method. The 'parse' method simply parses
# ARGV, while the 'parse!' method parses ARGV and removes
# any options found there, as well as any parameters for
# the options.
optparse.parse!

fail "give me a filename to create the ruby script within." unless options[:file]

PROJECTNAME = options[:file]

# filenames
MAIN       = File.join(PROJECTNAME , "#{PROJECTNAME}.rb")
RAKEFILE   = File.join(PROJECTNAME , 'Rakefile')
LIB        = File.join(PROJECTNAME , "lib" )
SPEC       = File.join(PROJECTNAME , 'spec')


[PROJECTNAME, LIB, SPEC].each do |dir|
  puts "creating #{dir}"
  Dir.mkdir dir
end

class String
  def camelize
    self.split("_").map(&:capitalize).join
  end
end

File.open(MAIN, 'w') do |file|
  file << <<-EOF
# #{PROJECTNAME}.rb ;; #{Time.now.year} (cc) Jan Riethmayer
# This work is licensend under a Creative Commons Attribution 3.0 license.
class #{PROJECTNAME.camelize}
  def foo
    "BAR"
  end
end
EOF
end

File.open(File.join(SPEC,"spec_helper.rb"), 'w') do |file|
  file << <<-EOF
# spec_helper.rb ;; #{Time.now.year} (cc) Jan Riethmayer
# This work is licensend under a Creative Commons Attribution 3.0 license.
project_root_folder = File.expand_path(File.dirname(__FILE__) + "/../")
Dir["#\{project_root_folder}/*.rb"].each do |file|
  require file
end

lib_folder = File.expand_path(File.dirname(__FILE__) + "/../lib/")
Dir["#\{lib_folder}/*.rb"].each do |file|
  require file
end
EOF
end

File.open(File.join(SPEC,"spec.opts"), 'w') do |file|
  file << <<-EOF
--color
--format specdoc
--loadby mtime
--reverse
EOF
end


File.open(File.join(SPEC,"#{PROJECTNAME}_spec.rb"), 'w') do |file|
  file << <<-EOF
# #{PROJECTNAME}_spec.rb ;; #{Time.now.year} (cc) Jan Riethmayer
# This work is licensend under a Creative Commons Attribution 3.0 license.
require "spec_helper"

describe "#{PROJECTNAME.camelize}" do
  it "should foo" do
    baz = #{PROJECTNAME.camelize}.new
    bar = baz.foo
    bar.should == "BAR"
  end
end
EOF
end

File.open(RAKEFILE, 'w') do |file|
  file << <<-EOF
require 'spec/rake/spectask'
task :default => :spec

desc "Runs rspec tests suite"
task :spec do
  Spec::Rake::SpecTask.new do |t|
    t.spec_opts = ["--color", "--format", "specdoc"]
  end
end
EOF
end

puts %x{tree #{PROJECTNAME}} if `which tree` =~ /bin\/tree/
