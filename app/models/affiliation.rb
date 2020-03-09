# frozen_string_literal: true

class Affiliation < ActiveRecord::Base
  belongs_to :user
  belongs_to :certificate_authority
end
