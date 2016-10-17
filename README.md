# OSS Inventory
Compiles a list of Open Source libraries used by your project(s).

## Setup
```bash
# install dependencies
bundle install

# create configuration file
cp config.yml{.example,}
```

## Configuration
After setting up the project, you should now have a file called config.yml.
This is where you list the repositories that you care to inventory.
Delete the existing examples and replace them with your own.

## Generating your inventory
Once you've listed your repositories in config.yml, it's time to run this tool:

```bash
bundle exec rake build_inventory
```

Depending on the number/size of your repositories, this may take a while.
When the task has finished, you'll be left with a bunch of .txt files in /tmp/oss-inventory/ folder.
Each one contains a list of the names, versions, and licenses used by the libraries on which your project depends.
That's it! Use these text files however you need.

## Running Tests
We have a test suite that outlines the project's basic functionality.
You can run it with the following:

```bash
bundle exec rspec
```
