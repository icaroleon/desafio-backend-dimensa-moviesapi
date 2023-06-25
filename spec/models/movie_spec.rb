require 'rails_helper'

RSpec.describe Movie, type: :model do
  describe "Test Movie Model" do
    let(:movie) { FactoryBot.build(:movie) }
  
    it "is valid with valid attributes" do
      expect(movie).to be_valid
    end
  
    it "is not valid without a title" do
      movie.title = nil
      expect(movie).to_not be_valid
    end
  
    it "is not valid without a genre" do
      movie.genre = nil
      expect(movie).to_not be_valid
    end
  
    it "is not valid without a year" do
      movie.year = nil
      expect(movie).to_not be_valid
    end
  
    it "is not valid without a country" do
      movie.country = nil
      expect(movie).to_not be_valid
    end
  
    it "is not valid without a description" do
      movie.description = nil
      expect(movie).to_not be_valid
    end
  
    it "is not valid without a published_at" do
      movie.published_at = nil
      expect(movie).to_not be_valid
    end
  
    it "is not valid with a duplicated title" do
      FactoryBot.create(:movie, title: "Duplicate Title")
      movie_with_duplicate_title = FactoryBot.build(:movie, title: "Duplicate Title")
      expect(movie_with_duplicate_title).to_not be_valid
    end
  end
end
