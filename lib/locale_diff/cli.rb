require 'thor'

module LocaleDiff
  class CLI < Thor

    desc "rummage", "Runs the locale_diff task"

    def rummage
      diff = LocaleDiff::Diff.new
      puts diff.rummage!
    end
  end
end