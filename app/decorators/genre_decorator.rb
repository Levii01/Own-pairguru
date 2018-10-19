class GenreDecorator < Draper::Decorator
  delegate_all
  decorates_association :movies
end
