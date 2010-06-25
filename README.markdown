# Tree Surgeon

Creates a ruby tree structure to start a ruby project with rspec.

## Installation

You'd like to symlink this file to your ~/bin directory
    git clone git://github.com:riethmayer/ruby-project-template.git
    ln -s ruby-project-template/treesurgeon.rb ~/bin/ts

## Usage
All my scripts follow the same schema. To run my script with the given symlink:
    > ts -f foo
    creating foo
    creating foo/lib
    creating foo/spec
    foo
    |-- .rspec        
    |-- foo.rb
    |-- lib
    `-- spec
        |-- foo_spec.rb
        `-- spec_helper.rb

## License

Fork, use and hack it as you like.

