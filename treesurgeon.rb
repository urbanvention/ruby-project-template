#!/usr/bin/env ruby -w

fail "give me a filename to create the ruby script within." unless ARGV[0]

PROJECTNAME = ARGV[0]

# filenames
MAIN       = File.join(PROJECTNAME , "#{PROJECTNAME}.rb")
LIB        = File.join(PROJECTNAME , "lib" )
SPEC       = File.join(PROJECTNAME , 'spec')
AUTOTEST   = File.join(PROJECTNAME , 'autotest')

[PROJECTNAME, LIB, SPEC, AUTOTEST].each do |dir|
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
class #{PROJECTNAME.camelize}
  def foo
    "BAR"
  end
end
EOF
end

File.open(File.join(SPEC,"spec_helper.rb"), 'w') do |file|
  file << <<-EOF
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

File.open(File.join(PROJECTNAME,".rspec"), 'w') do |file|
  file << <<-EOF
--color
EOF
end


File.open(File.join(SPEC,"#{PROJECTNAME}_spec.rb"), 'w') do |file|
  file << <<-EOF
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

File.open(File.join(AUTOTEST,"discover.rb"), 'w') do |file|
  file << <<-EOF
Autotest.add_discovery { "rspec2" }
EOF
end

puts %x{tree #{PROJECTNAME}} if `which tree` =~ /bin\/tree/
