require 'spec_helper'
require 'missing_text'
require 'missing_text/runner'
require 'missing_text/writer'

describe MissingText::Runner do
  context :runner do
    it "should run everything successfully given the dummy app" do
      MissingText::Runner.run
      expect(MissingText::Batch.count).to eq(1)
      expect(MissingText::Record.count).to eq(5)
      expect(MissingText::Entry.count).to eq(27)
    end

    it "should skip specified directories as outlined in the initializer" do
      
      allow(MissingText).to receive(:skip_directories).and_return(["rbs"])

      MissingText::Runner.run
      expect(MissingText::Record.where(parent_dir: "rbs")).to eq([])
    end

    it "should search specified root directory in the initializer" do
      MissingText::Runner.run
      expect(MissingText::Record.where(parent_dir: File.basename(MissingText.locale_root)).count).to eq(1)
    end

    it "should railse FiletypeErrors if we attempt to read in a file that is not a .yml or a .rb" do
      # create file
      File.open("#{MissingText.app_root}/#{MissingText.locale_root}hash1/delete_me.txt", 'w+') do |f|
        f.write("I'm a textfile")
      end

      expect{ MissingText::Runner.run }.to raise_error(MissingText::Runner::FiletypeError)

      # delete file
      File.delete("#{MissingText.app_root}/#{MissingText.locale_root}hash1/delete_me.txt")
    end
  end
end