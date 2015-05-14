require 'spec_helper'
require 'locale_diff'
require 'locale_diff/runner'
require 'locale_diff/writer'

describe LocaleDiff::Runner do
  context :runner do
    it "should run everything successfully given the dummy app" do
      LocaleDiff::Runner.run
      expect(LocaleDiff::Batch.count).to eq(1)
      expect(LocaleDiff::Record.count).to eq(5)
      expect(LocaleDiff::Entry.count).to eq(27)
    end

    it "should skip specified directories as outlined in the initializer" do
      
      allow(LocaleDiff).to receive(:skip_directories).and_return(["rbs"])

      LocaleDiff::Runner.run
      expect(LocaleDiff::Record.where(parent_dir: "rbs")).to eq([])
    end

    it "should search specified root directory in the initializer" do
      LocaleDiff::Runner.run
      expect(LocaleDiff::Record.where(parent_dir: File.basename(LocaleDiff.locale_root)).count).to eq(1)
    end

    it "should railse FiletypeErrors if we attempt to read in a file that is not a .yml or a .rb" do
      # create file
      File.open("#{LocaleDiff.app_root}/#{LocaleDiff.locale_root}hash1/delete_me.txt", 'w+') do |f|
        f.write("I'm a textfile")
      end

      expect{ LocaleDiff::Runner.run }.to raise_error(LocaleDiff::Runner::FiletypeError)

      # delete file
      File.delete("#{LocaleDiff.app_root}/#{LocaleDiff.locale_root}hash1/delete_me.txt")
    end
  end
end