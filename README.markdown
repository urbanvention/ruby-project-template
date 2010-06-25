# Tree Surgeon
Creates a ruby tree structure to start a ruby project with rspec.

## Installation
You'd like to symlink this file to your ~/bin directory
    git clone git://github.com:riethmayer/ruby-project-template.git
    ln -s ruby-project-template/treesurgeon.rb ~/bin/ts
    
## Requirements
Bundler
    gem install bundler

## Usage
All my scripts follow the same schema. To run my script with the given symlink:
    > ts -f foo
    creating foo
    creating foo/lib
    creating foo/spec
    foo
    |-- .rspec
    |-- Gemfile    
    |-- foo.rb
    |-- lib
    `-- spec
        |-- foo_spec.rb
        `-- spec_helper.rb

Now go into the project and install all missing gems:
    bundle install

## Why does my project start that slow?
Because of the dependency resolution of Bundler your startup takes some time.

## License
Fork, use and hack it as you like.
