require 'spec_helper'
require 'missing_text'

describe MissingText::Diff do
  before(:each) do
    @args = [
      {lang: "en", type: ".yml", path: "#{file_path}hash1/en.yml"},
      {lang: "fr", type: ".yml", path: "#{file_path}hash1/fr.yml"}
    ]
  end

  context :initialization do

    it "should build languages out of specified options file" do
      expect(MissingText::Diff.new(@args).languages).to eq([:en, :fr])
    end

    it "should raise an exception if a yaml file can not be read" do
      @args[0][:path] = 'nohash/en.yml'
      expect{ MissingText::Diff.new(@args) }.to raise_error(MissingText::Diff::YamlParsingError)
    end

    it "should read in a file saved as an .rb" do
     expect( MissingText::Diff.new([{lang: "en", type: ".rb", path: "#{file_path}rbs/en.rb"}]).languages ).to eq([:en])
    end

    it "should raise an exception if an rn file can not be read" do
      @args[0][:type] = ".rb"
      @args[0][:path] = 'nohash/en.rb'
      expect{ MissingText::Diff.new(@args) }.to raise_error(MissingText::Diff::RbParsingError)
    end

    it "should save the files that are opened and remember the parent directory" do
      @diff = MissingText::Diff.new(@args)
      expect(@diff.files).to eq(
        [
          {:lang=>"en", :type=>".yml", :path=>"#{file_path}hash1/en.yml"},
          {:lang=>"fr", :type=>".yml", :path=>"#{file_path}hash1/fr.yml"}]
        )
      expect(@diff.parent_dir).to eq("hash1")
    end
  end

  context :symbolize_keys_nested do

    before(:each) do
      @hash1 = {"key1" => "value1", "key2" => "value2" } 
      @hash2 = {"key3" => @hash1 }
      @hash3 = {"key4" => @hash2 }
      @hash4 = {"key5" => @hash3 }
      @diff = MissingText::Diff.new(@args)
    end

    it "should symbolize keys for a flat hash" do
      result = @diff.symbolize_keys_nested!(@hash1)
      expect(result).to eq({key1: "value1", key2: "value2"})
    end

    it "should symbolize keys for a first order hash" do
      result = @diff.symbolize_keys_nested!(@hash2)
      expect(result).to eq({key3: {key1: "value1", key2: "value2"}})
    end

    it "should symbolize keys for a second order hash" do
      result = @diff.symbolize_keys_nested!(@hash3)
      expect(result).to eq({key4: {key3: {key1: "value1", key2: "value2"}}})
    end 

    it "should symbolize keys for a third order hash" do
      result = @diff.symbolize_keys_nested!(@hash4)
      expect(result).to eq({key5: {key4: {key3: {key1: "value1", key2: "value2"}}}})
    end

  end

  context :keymapping do
    it "should create a proper keymap for hash1_en.yml" do
      @args = [{lang: "en", type: ".yml", path: "#{file_path}hash1/en.yml"}]
      @diff = MissingText::Diff.new(@args)
      @diff.create_langmap!
      expect(@diff.langmap[:en]).to match_array([[:obj1], [:obj2], [:obj3, :obj31], [:obj3, :obj32]])
    end

    it "should create a proper keymap for hash1_fr.yml" do
      @args = [{lang: "fr", type: ".yml", path: "#{file_path}hash1/fr.yml"}]
      @diff = MissingText::Diff.new(@args)
      @diff.create_langmap!
      expect(@diff.langmap[:fr]).to match_array([[:obj1], [:obj3, :obj31]])
    end

    it "should create a proper keymap for hash2_en.yml" do
      @args = [{lang: "en", type: ".yml", path: "#{file_path}hash2/en.yml"}]
      @diff = MissingText::Diff.new(@args)
      @diff.create_langmap!
      expect(@diff.langmap[:en]).to match_array([[:obj1], [:obj2], [:obj3], [:obj4, :obj41], [:obj4, :obj42], [:obj4, :obj43, :obj431], [:obj4, :obj43, :obj432], [:obj4, :obj44], [:obj5], [:obj6]])
    end

    it "should create a proper keymap for hash2_fr.yml" do
      @args = [{lang: "fr", type: ".yml", path: "#{file_path}hash2/fr.yml"}]
      @diff = MissingText::Diff.new(@args)
      @diff.create_langmap!
      expect(@diff.langmap[:fr]).to match_array([[:obj1], [:obj4, :obj41], [:obj4, :obj43, :obj431], [:obj4, :obj44], [:obj5]])
    end

    it "should create a proper keymap for hash3_en.yml" do
      @args = [{lang: "en", type: ".yml", path: "#{file_path}hash3/en.yml"}]
      @diff = MissingText::Diff.new(@args)
      @diff.create_langmap!
      expect(@diff.langmap[:en]).to match_array([[:obj1, :obj13, :obj131], [:obj1, :obj13, :obj132], [:obj1, :obj13, :obj134], [:obj1, :obj14]])
    end

    it "should create a proper keymap for hash3_fr.yml" do
      @args = [{lang: "fr", type: ".yml", path: "#{file_path}hash3/fr.yml"}]
      @diff = MissingText::Diff.new(@args)
      @diff.create_langmap!
      expect(@diff.langmap[:fr]).to match_array([[:obj1, :obj11], [:obj1, :obj12], [:obj1, :obj13, :obj131], [:obj1, :obj13, :obj132], [:obj1, :obj13, :obj133, :obj1331], [:obj1, :obj13, :obj134], [:obj1, :obj14], [:obj1, :obj15]])
    end
  end

  context :diffmapping do
    it "should create a proper diffmap " do
      @args = [
        {lang: "en", type: ".yml", path: "#{file_path}hash1/en.yml"},
        {lang: "fr", type: ".yml", path: "#{file_path}hash1/fr.yml"}
      ]
      @diff = MissingText::Diff.new(@args)
      @diff.create_langmap!
      @diff.create_diffmap!
      expect(@diff.diffmap[[:en, :fr]]).to match_array([[:obj2], [:obj3, :obj32]])
      expect(@diff.diffmap[[:fr, :en]]).to match_array([])
    end

    it "should create a second proper diffmap" do
      @args = [
        {lang: "en", type: ".yml", path: "#{file_path}hash2/en.yml"},
        {lang: "fr", type: ".yml", path: "#{file_path}hash2/fr.yml"}
      ]
      @diff = MissingText::Diff.new(@args)
      @diff.create_langmap!
      @diff.create_diffmap!
      expect(@diff.diffmap[[:en, :fr]]).to match_array([[:obj2], [:obj3], [:obj4, :obj42], [:obj4, :obj43, :obj432], [:obj6]])
      expect(@diff.diffmap[[:fr, :en]]).to match_array([])
    end

    it "should create a third proper diffmap" do
      @args = [
        {lang: "en", type: ".yml", path: "#{file_path}hash3/en.yml"},
        {lang: "fr", type: ".yml", path: "#{file_path}hash3/fr.yml"}
      ]
      @diff = MissingText::Diff.new(@args)
      @diff.create_langmap!
      @diff.create_diffmap!
      expect(@diff.diffmap[[:en, :fr]]).to match_array([])
      expect(@diff.diffmap[[:fr, :en]]).to match_array([[:obj1, :obj11], [:obj1, :obj12], [:obj1, :obj13, :obj133, :obj1331], [:obj1, :obj15]])
    end

    it "should create a diffmap for the parent locale files" do
      @args = [
        {lang: "en", type: ".yml", path: "#{file_path}en.yml"},
        {lang: "fr", type: ".yml", path: "#{file_path}fr.yml"},
        {lang: "es", type: ".yml", path: "#{file_path}es.yml"}
      ]

      @diff = MissingText::Diff.new(@args)
      @diff.create_langmap!
      @diff.create_diffmap!
      expect(@diff.diffmap[[:en, :fr]]).to match_array([[:obj1, :obj13, :obj131], [:obj1, :obj13, :obj132], [:obj1, :obj13, :obj134], [:obj1, :obj14]])
      expect(@diff.diffmap[[:en, :es]]).to match_array([[:obj2, :obj22], [:obj2, :obj24]])
      expect(@diff.diffmap[[:fr, :en]]).to match_array([[:obj6]])
      expect(@diff.diffmap[[:fr, :es]]).to match_array([[:obj2, :obj22], [:obj2, :obj24], [:obj6]])
      expect(@diff.diffmap[[:es, :en]]).to match_array([[:obj2, :obj27], [:obj2, :obj28, :obj281], [:obj2, :obj28, :obj282]])
      expect(@diff.diffmap[[:es, :fr]]).to match_array([[:obj1, :obj13, :obj131], [:obj1, :obj13, :obj132], [:obj1, :obj13, :obj134], [:obj1, :obj14], [:obj2, :obj27], [:obj2, :obj28, :obj281], [:obj2, :obj28, :obj282]])
    end
  end

  context :writer do
    it "should create the writer with all the info from diff.rb" do
      MissingText::Batch.create
      @diff = MissingText::Diff.new(@args)
      @diff.begin!
      # sanity check to make sure writer is being created

      @writer = @diff.writer

      expect(@writer.diffmap).to eq(@diff.diffmap)
      expect(MissingText::Record.count).to eq(1)
      expect(MissingText::Entry.count).to eq(2)

      @record = MissingText::Record.first
      @entry1 = MissingText::Entry.first
      @entry2 = MissingText::Entry.last

      expect(@record.parent_dir).to eq(@diff.parent_dir)
      expect(@record.files).to eq(@diff.files)
      expect(@record.missing_text_batch_id).to eq(MissingText::Batch.last.id)

      tests = [
        [@record, [
          [:parent_dir, @diff.parent_dir],
          [:files, @diff.files],
          [:missing_text_batch_id, MissingText::Batch.last.id]
        ]],

        [@entry1, [
          [:missing_text_records_id, @record.id],
          [:base_language, "en"],
          [:base_string, "made often from the juices that run naturally from meat or vegetables during cooking"],
          [:target_languages, [:fr]],
          [:locale_code, "obj2"]
        ]],

        [@entry2, [
          [:missing_text_records_id, @record.id],
          [:base_language, "en"],
          [:base_string, "the term can refer to a wider variety of sauces"],
          [:target_languages, [:fr]],
          [:locale_code, "obj3.obj32"]
        ]]
      ]
      
      tests.each do |record, test_values|
        test_values.each do |test_case|
          expect_value(record, test_case[0], test_case[1])
        end
      end

    end
  end

end

def file_path
  "#{MissingText.app_root}/#{MissingText.locale_root}"
end

def expect_value(entry, attribute, value)
  expect(entry.send(attribute)).to eq(value)
end
