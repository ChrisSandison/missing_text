require 'thor'

module MissingText
  class CLI < Thor

    desc "rummage", "Runs the missing_text task"

    def rummage
      diff = MissingText::Diff.new
      puts diff.rummage!
    end
  end
end