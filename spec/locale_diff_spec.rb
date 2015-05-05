require 'spec_helper'
require 'locale_diff'

describe LocaleDiff::Diff do
  before(:each) do
    @args = {
        en: 'hash1/en.yml',
        fr: 'hash1/fr.yml'
      }
  end

  context :initialization do
    it "should build languages out of specified options file" do
      @diff = LocaleDiff::Diff.new(@args)
      expect(@diff.languages).to eq([:en, :fr])
      binding.pry
    end
  end
end
