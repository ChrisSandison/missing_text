require 'spec_helper'
require 'locale_diff'

describe LocaleDiff::Diff do
  before(:each) do
    # TODO: write test files dynamically using faker and rand. Delete this files in an after
    @args = {
        en: 'hash1/en.yml',
        fr: 'hash1/fr.yml'
      }
  end

  context :initialization do

    it "should build languages out of specified options file" do
      expect(LocaleDiff::Diff.new(@args).languages).to eq([:en, :fr])
    end

    it "should raise an exception if a yaml file can not be read" do
      @args[:en] = 'nohash/en.yml'
      expect{ LocaleDiff::Diff.new(@args) }.to raise_error
    end

  end

  context :symbolize_keys_nested do

    before(:each) do
      @hash1 = {"key1" => "value1", "key2" => "value2" } 
      @hash2 = {"key3" => @hash1 }
      @hash3 = {"key4" => @hash2 }
      @hash4 = {"key5" => @hash3 }
      @diff = LocaleDiff::Diff.new(@args)
    end

    it "should symbolize keys for a flat hash" do
      result = @diff.symbolize_keys_nested!(@hash1)
      result.should == {key1: "value1", key2: "value2"}
    end

    it "should symbolize keys for a first order hash" do
      result = @diff.symbolize_keys_nested!(@hash2)
      result.should == {key3: {key1: "value1", key2: "value2"}}
    end

    it "should symbolize keys for a second order hash" do
      result = @diff.symbolize_keys_nested!(@hash3)
      result.should == {key4: {key3: {key1: "value1", key2: "value2"}}}
    end 

    it "should symbolize keys for a third order hash" do
      result = @diff.symbolize_keys_nested!(@hash4)
      result.should == {key5: {key4: {key3: {key1: "value1", key2: "value2"}}}}
    end

  end

  context :keymapping do
    it "should create a proper keymap for hash1_en.yml" do
      @args = {en: 'hash1/en.yml'}
      @diff = LocaleDiff::Diff.new(@args)
      @diff.create_langmap!
      @diff.langmap[:en].should =~ [[:obj1], [:obj2], [:obj3, :obj31], [:obj3, :obj32]]
    end

    it "should create a proper keymap for hash1_fr.yml" do
      @args = {fr: 'hash1/fr.yml'}
      @diff = LocaleDiff::Diff.new(@args)
      @diff.create_langmap!
      @diff.langmap[:fr].should =~ [[:obj1], [:obj3, :obj31]]
    end

    it "should create a proper keymap for hash2_en.yml" do
      @args = {en: 'hash2/en.yml'}
      @diff = LocaleDiff::Diff.new(@args)
      @diff.create_langmap!
      @diff.langmap[:en].should =~ [[:obj1], [:obj2], [:obj3], [:obj4, :obj41], [:obj4, :obj42], [:obj4, :obj43, :obj431], [:obj4, :obj43, :obj432], [:obj4, :obj44], [:obj5], [:obj6]] #this does match what I've worked out in the test hash file
    end

    it "should create a proper keymap for hash2_fr.yml" do
      @args = {fr: 'hash2/fr.yml'}
      @diff = LocaleDiff::Diff.new(@args)
      @diff.create_langmap!
      @diff.langmap[:fr].should =~ [[:obj1], [:obj4, :obj41], [:obj4, :obj43, :obj431], [:obj4, :obj44], [:obj5]] #this does match what I've worked out in the test hash file
    end

    it "should create a proper keymap for hash3_en.yml" do
      @args = {en: "hash3/en.yml"}
      @diff = LocaleDiff::Diff.new(@args)
      @diff.create_langmap!
      @diff.langmap[:en].should =~ [[:obj1, :obj13, :obj131], [:obj1, :obj13, :obj132], [:obj1, :obj14]]
    end

    it "should create a proper keymap for hash3_fr.yml" do
      @args = {fr: "hash3/fr.yml"}
      @diff = LocaleDiff::Diff.new(@args)
      @diff.create_langmap!
      @diff.langmap[:fr].should =~ [[:obj1, :obj11], [:obj1, :obj12], [:obj1, :obj13, :obj131], [:obj1, :obj13, :obj132], [:obj1, :obj13, :obj133, :obj1331], [:obj1, :obj14], [:obj1, :obj15]]
    end
  end

  context :diffmapping do
    it "should create a proper diffmap " do
      @args = {
        en: "hash1/en.yml",
        fr: "hash1/fr.yml"
      }
      @diff = LocaleDiff::Diff.new(@args)
      @diff.create_langmap!
      @diff.create_diffmap!
      @diff.diffmap[[:en, :fr]].should =~ [[:obj2], [:obj3, :obj32]]
      @diff.diffmap[[:fr, :en]].should =~ []
    end

    it "should create a second proper diffmap" do
      @args = {
        en: "hash2/en.yml",
        fr: "hash2/fr.yml"
      }
      @diff = LocaleDiff::Diff.new(@args)
      @diff.create_langmap!
      @diff.create_diffmap!
      @diff.diffmap[[:en, :fr]].should =~ [[:obj2], [:obj3], [:obj4, :obj42], [:obj4, :obj43, :obj432], [:obj6]]
      @diff.diffmap[[:fr, :en]].should =~ []
    end

    it "should create a third proper diffmap" do
      @args = {
        en: "hash3/en.yml",
        fr: "hash3/fr.yml"
      }
      @diff = LocaleDiff::Diff.new(@args)
      @diff.create_langmap!
      @diff.create_diffmap!
      @diff.diffmap[[:en, :fr]].should =~ []
      @diff.diffmap[[:fr, :en]].should =~ [[:obj1, :obj11], [:obj1, :obj12], [:obj1, :obj13, :obj133, :obj1331], [:obj1, :obj15]]
    end
  end
end
