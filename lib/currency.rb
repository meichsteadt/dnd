class Currency
  attr_accessor :type, :amount
  def initialize(**params)
    @type = params[:type]
    @amount = params[:amount]
  end

  def to_h
    JSON.parse self.to_json
  end

  def to_s
    pieces = self.amount > 1 ? "pieces" : "piece"

    "#{self.amount} #{self.type} #{pieces}"
  end

  def self.types
    ['platinum', 'electrum', 'gold', 'silver', 'copper'].map {|e| e.upcase}
  end

  def mongoize
    self.to_h
  end

  class << self

    # Get the object as it was stored in the database, and instantiate
    # this custom class from it.
    def demongoize(object)
      object = object.to_h.symbolize_keys
      Currency.new(object)
    end

    # Takes any possible object and converts it to how it would be
    # stored in the database.
    def mongoize(object)
      object = object.to_h.symbolize_keys
      case object
      when Currency then object.mongoize
      when Hash then Currency.new(object).mongoize
      else object
      end
    end

    # Converts the object that was supplied to a criteria and converts it
    # into a database friendly form.
    def evolve(object)
      object = object.to_h.symbolize_keys
      case object
      when Currency then object.mongoize
      else object
      end
    end
  end

end
