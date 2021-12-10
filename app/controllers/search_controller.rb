class SearchController < ApplicationController
  def create
    search
    respond_to do |format|
      format.js
    end
  end

  private
  def search
    @query = params[:query]
    regex = Regexp.new(@query, true)
    @results = (
      Monster.where(name: regex).pluck(:id, :name).map do |e|
        SearchResult.new(*e.map(&:to_s) << 'Monster')
      end +
      Spell.where(name: regex).pluck(:id, :name).map do |e|
        SearchResult.new(*e.map(&:to_s) << 'Spell')
      end +
      MagicItem.where(name: regex).pluck(:id, :name).map do |e|
        SearchResult.new(*e.map(&:to_s) << 'MagicItem')
      end +
      Encounter.where(name: regex).pluck(:id, :name).map do |e|
        SearchResult.new(*e.map(&:to_s) << 'Encounter')
      end
    ).sort_by {|e| e.name}.group_by {|e| e.type}
  end

end

SearchResult = Struct.new(:id, :name, :type) do
  def route
    "/#{self.type.tableize}/#{self.id}.js?show=true"
  end

  def emoji
    case self.type
    when "Monster"
      return "🐉 "
    when "Spell"
      return "📖"
    when "MagicItem"
      return "🔮️"
    when "Encounter"
      return "🗡️🛡️"
    end
  end
end
