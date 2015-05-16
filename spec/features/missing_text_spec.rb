require 'missing_text'
require 'missing_text/writer'

feature 'MissingText' do

  scenario 'User visits missing_text for first time' do
    visit '/missing_text'

    expect(page).to have_content("Thank you for trying Missing Text! When you click the button below, this engine will search for and display any missing translations from your locale files below. These sessions will be versioned, so you will have the ability to navigate them by date, or clear their history.")
    expect(page).to have_content("Please visit the Missing Text github for full configuration options.")
    expect(MissingText::Batch.count).to eq(0)
    expect(MissingText::Record.count).to eq(0)
    expect(MissingText::Entry.count).to eq(0)

    click_link("Run Missing Text")

    expect(page).to have_content("Missing text last run on #{MissingText::Batch.last.created_time}")
    expect(MissingText::Batch.count).to eq(1)
    expect(page).to have_content("Re-Run Missing Text")

    MissingText::Record.all.each do |record|
      if record.entries.present?
       expect(page).to have_content("In #{File.expand_path('..', record.files.first[:path])} the following entries are missing:")
      else
        expect(page).to_not have_content("In #{File.expand_path('..', record.files.first[:path])} the following entries are missing:")
      end
    end
  end

  scenario 'User visits missing_text for second time and re-runs it' do
    @batch = FactoryGirl.create(:missing_text_batch)
    @record = FactoryGirl.create(:missing_text_record, missing_text_batch_id: @batch.id)

    3.times do
      FactoryGirl.create(:missing_text_entry, missing_text_records_id: @record.id)
    end

    visit '/missing_text'

    expect(page).to have_content("Missing text last run on #{@batch.created_time}")
    expect(MissingText::Batch.count).to eq(1)
    expect(page).to have_content("No older Missing Text sessions!")

    click_link("Re-Run Missing Text")
    expect(MissingText::Batch.count).to eq(2)
    expect(page).to have_content("Missing text last run on #{MissingText::Batch.last.created_time}")
  end

  scenario 'User clears history' do
    @batch = FactoryGirl.create(:missing_text_batch)
    @record = FactoryGirl.create(:missing_text_record, missing_text_batch_id: @batch.id)

    3.times do
      FactoryGirl.create(:missing_text_entry, missing_text_records_id: @record.id)
    end

    visit '/missing_text'

    expect(page).to have_content("Missing text last run on #{@batch.created_time}")
    expect(MissingText::Batch.count).to eq(1)
    expect(page).to have_content("No older Missing Text sessions!")

    click_link('Clear History')

    expect(MissingText::Batch.count).to eq(0)
    expect(page).to have_content("Thank you for trying Missing Text! When you click the button below, this engine will search for and display any missing translations from your locale files below. These sessions will be versioned, so you will have the ability to navigate them by date, or clear their history.")
  end
end