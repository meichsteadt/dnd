module ObjectWithOrder
  def update_orders(new_order)

    original_order = self.order
    self.update(order: -1)

    if original_order.nil?
      self.others.order(order: :desc).where('"order" >= ?', new_order).each {|e| e.increment_order(1)}
    elsif new_order < original_order
      self.others.order(order: :desc).where('"order" < ? AND "order" >= ?', original_order, new_order).each {|e| e.increment_order(1)}
    elsif new_order > original_order
      self.others.order(:order).where('"order" > ? AND "order" <= ?', original_order, new_order).each {|e| e.increment_order(-1)}
    end
    self.update(order: new_order)
  end

  def increment_order(n)
    self.update(order: self.order + n)
  end

  def max_number
    return 1 if (self.parent.nil? || self.others.count < 1)
    return self.others.count + 1
  end

  def others
    self.parent.association(self.class.to_s.pluralize.downcase).scope.where.not(id: self.id)
  end

  def parent
    case self.class.to_s
    when 'Book'
      return self.campaign
    when 'Chapter'
      return self.book
    when 'Page'
      return self.chapter
    end
  end
end
