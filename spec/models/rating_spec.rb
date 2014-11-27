require 'rails_helper'

describe Rating, :type => :model do
  it { is_expected.to validate_inclusion_of(:value).in_array(RatingValues.all) }
end
