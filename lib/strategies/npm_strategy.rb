require 'strategies/printed_strategy'
require 'json'

class NpmStrategy < PrintedStrategy
  def name
    :npm
  end

  def get_libraries
    Dir.chdir(repo.file_location) do
      `npm install > /dev/null 2>&1`

      `npm list --parseable`.strip.split("\n").map do |package_path|
        package_contents = File.read(package_path.strip + '/package.json')
        package_info = JSON.parse(package_contents)

        {
          "name" => package_info['name'],
          "version" => package_info['version'],
          "license" => get_license(package_info)
        }
      end
    end
  end

  protected

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
