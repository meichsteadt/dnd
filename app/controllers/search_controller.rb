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
    return [] if @query.nil? || @query.empty?
    regex = Regexp.new(@query, true)

    @results = (
      Monster.where(name: regex, :_type.nin => ["Npc"]).pluck(:id, :name).map do |e|
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
      end +
      Map.where(name: regex).pluck(:id, :name).map do |e|
        SearchResult.new(*e.map(&:to_s) << 'Map')
      end +
      Npc.where(name: regex).pluck(:id, :name).map do |e|
        SearchResult.new(*e.map(&:to_s) << 'NPC')
      end  +
      (current_user.chapters.joins(:book).where("lower(books.name) like ?", "%#{@query.downcase}%").pluck(:id, :name) +
      current_user.chapters.where("lower(chapters.name) like ?", "%#{@query.downcase}%").pluck(:id, :name)).uniq.map do |e|
        SearchResult.new(*e.map(&:to_s) << 'Side Quest')
      end
    ).sort_by {|e| e.name}.group_by {|e| e.type}
  end

end

SearchResult = Struct.new(:id, :name, :type) do
  include HTMLParser
  def route
    "/#{self.type.tableize}/#{self.id}.js?show=true"
  end

  def emoji
    super(self.type)
  end
end
