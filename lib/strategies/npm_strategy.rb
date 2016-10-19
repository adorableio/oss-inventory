require 'inventory_printer'
require 'json'

class NpmStrategy
  attr_reader :repo, :strategy_name

  def initialize(repo)
    @strategy_name = :npm
    @repo = repo
  end

  def perform
    packages = get_packages
    InventoryPrinter.new(repo, packages, :npm)
  end

  private

  def get_packages
    Dir.chdir(repo.file_location) do
      `npm install > /dev/null 2>&1`

      `npm list --parseable`.strip.split("\n").map do |package_path|
        package_name = package_path.split("/").last
        package_info = JSON.parse(`npm info #{package_name} --json`)

        {
          "name" => package_info['name'],
          "version" => package_info['version'],
          "license" => get_license(package_info)
        }
      end
    end
  end

  def get_license(package_info)
    value = package_info['license'] || package_info['licenses']

    if value.is_a?(Array)
      value.map do |license|
        if license.is_a?(Hash)
          license['type']
        else
          license
        end
      end.join(', ')
    elsif value.is_a?(Hash)
      value['type']
    else
      value
    end
  end
end
