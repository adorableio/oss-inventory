require "strategies/printed_strategy"

class BundlerStrategy < PrintedStrategy
  def name
    :bundler
  end

  def get_libraries
    Dir.chdir(repo.file_location) do
      Bundler.with_clean_env do
        `bundle install`

        `bundle show`
          .split("\n")
          .select { |line| line.strip.start_with?('*') }
          .map do |line|
            _, gem_name, version = line.split
            version = version.gsub(/[()]/, '')
            license = get_license(gem_name)

            {
              "name" => gem_name,
              "version" => version,
              "license" => license
            }
          end
      end
    end
  end

  protected

  def get_license(gem_name)
    license_lines = `gem list #{gem_name} --details`
      .split("\n")
      .map(&:strip)
      .grep(/license/i)

    return 'NOT_FOUND' if license_lines.empty?

    license_lines
      .first
      .gsub(/licenses?:/i, '')
      .strip
  end
end
