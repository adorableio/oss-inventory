# OSS Inventory [![CircleCI](https://circleci.com/gh/adorableio/oss-inventory.svg?style=svg&circle-token=3b3596811135edc5bb344beb6df3ad9b6e68be71)](https://circleci.com/gh/adorableio/oss-inventory)

Compiles a list of Open Source libraries used by your project(s).

## Setup
```bash
# clone this repo
git clone git@github.com:adorableio/oss-inventory.git
cd oss-inventory

# install dependencies
bundle install

# create configuration file
cp config.yml{.example,}
```

## Configuration
After setting up the project, you should now have a file called config.yml.
This is where you list the repositories that you care to inventory, along with where you wish the inventory files to be located.
Delete the existing examples and replace them with your own.

## Generating your inventory
Once you've listed your repositories in config.yml, it's time to run this tool:

```bash
bundle exec rake build_inventory
```

Depending on the number/size of your repositories, this may take a while.
When the task has finished, you'll be left with a bunch of .tsv files in the folder you specified (in config.yml).
Each one contains a list of the names, versions, and licenses used by the libraries on which your project depends.
That's it! Use these text files however you need.

## Running Tests
We have a test suite that outlines the project's basic functionality.
You can run it with the following:

```bash
bundle exec rspec
```
