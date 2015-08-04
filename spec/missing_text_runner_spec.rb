require 'spec_helper'
require 'missing_text'
require 'missing_text/runner'
require 'missing_text/writer'

describe MissingText::Runner do

  before(:each) do
    allow(MissingText).to receive(:skip_patterns).and_return([/([\w\-\_\.]+)+(en|fr|es|en\-US)(\.)?([\w\-\_\.]+)?(yml|rb|txt)/])
    allow(MissingText).to receive(:skip_directories).and_return(['admin', 'account', 'borrowers', 'calculator', 'dashboard', 'documents', 'esignatures', 'financeit_mailer', 'industries', 'loan_application', 'loan_exceptions', 'loan_steps', 'loans', 'occupations', 'partner_referrals', 'partners', 'public', 'regions', 'reports', 'sessions', 'tour', 'vehicles', 'will_paginate'])
  end

  context :runner do
    it "should run everything successfully given the dummy app" do
      MissingText::Runner.run
      expect(MissingText::Batch.count).to eq(1)
      expect(MissingText::Record.count).to eq(5)
      expect(MissingText::Entry.count).to eq(28)
    end

    it "should skip specified directories as outlined in the initializer" do
      
      allow(MissingText).to receive(:skip_directories).and_return(["rbs"])

      MissingText::Runner.run
      expect(MissingText::Record.where(parent_dir: "rbs")).to eq([])
    end

    it "should skip specified filename types, as outlined in the initializers" do
      allow(MissingText).to receive(:skip_patterns).and_return([/en\-US\.yml/])

      File.open("#{MissingText.app_root}/#{MissingText.locale_root}hash1/en-US.yml", "w+") do |f|
          f.write({"en-US" => {"accounts" => "Hello"}}.to_yaml)
        end

      MissingText::Runner.run

      record = MissingText::Record.where(parent_dir: "hash1").first
      all_files = record.files.map{ |file| file[:lang]}

      expect(all_files.include?("en-US")).to eq(false)

      # delete file
      File.delete("#{MissingText.app_root}/#{MissingText.locale_root}hash1/en-US.yml")
    end 

    it "should create a warning when the regex matches too strictly" do
      allow(MissingText).to receive(:skip_patterns).and_return([/.*/])

      MissingText::Runner.run

      expect(MissingText::Warning.where(warning_type: MissingText::Warning::STRICT_REGEX).count).to eq(5)
    end

    it "should search specified root directory in the initializer" do
      MissingText::Runner.run
      expect(MissingText::Record.where(parent_dir: File.basename(MissingText.locale_root)).count).to eq(1)
    end

    it "should railse FiletypeErrors if we attempt to read in a file that is not a .yml or a .rb" do
      # create file

      MissingText::Runner.run

      expect(MissingText::Warning.count).to eq(3)
      warning = MissingText::Warning.first
      expect(warning.filename).to eq("#{MissingText.app_root}/#{MissingText.locale_root}hash1/delete_me.txt")
      expect(warning.warning_type).to eq(MissingText::Warning::FILE_TYPE_ERROR)

    end
  end
end