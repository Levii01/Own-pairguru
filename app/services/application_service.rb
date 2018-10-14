class ApplicationService
  # include Dry::Monads::Result::Mixin

  def self.call(*args)
    new.call(*args)
  end
end
