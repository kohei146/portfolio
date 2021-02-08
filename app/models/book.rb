class Book < ApplicationRecord
  
  belongs_to :users, optional: true
end
