module HTMLParser
  def parsed_html
    splits_with_white_space = self.html.split(/(<[^>]*>[^<]*<\/[^>]+>)/)
    splits_with_white_space.map {|e| self.parse_element(e)}.join("")
  end

  def hipster
    JSON.parse(RestClient.get("http://hipsum.co/api/?type=hipster").to_s)[0]
  end

  def get_element_tag(elem_string)
    match = elem_string.match(/(?<=<)[^>\/\s]+/)
    match = match ? match.to_s : elem_string
  end

  def parse_element(element)
    elem_type = get_element_tag(element)
    _emoji = self.emoji(elem_type.camelize)
    case elem_type
    when "monster"
      id = element.match(/(?<=id=")[^"]+/).to_s
      monster_name = Page.get_monsters[id]
      emoji = SearchResult.new(nil, nil, )
      return  "<a id='html_monster_#{id}' class='html_monster btn-link' data-id='#{id}'>#{_emoji} #{monster_name}</a>"
    when "spell"
      id = element.match(/(?<=id=")[^"]+/).to_s
      spell_name = Page.get_spells[id]
      "<span class='spell' id='#{id}' data-id='#{id}'>#{_emoji} #{spell_name.downcase}</span>"
    when "magic_item"
      id = element.match(/(?<=id=")[^"]+/).to_s
      item_name = Page.get_magic_items[id]
      "<span class='magic_item' id='#{id}' data-id='#{id}'>#{_emoji} #{item_name.downcase}</span>"
    when "encounter"
      id = element.match(/(?<=id=")[^"]+/).to_s
      encounter = Page.get_encounters[id]
      "<span class='encounter btn-link' id='#{id}' data-id='#{id}'>🗡️️#{encounter.downcase}🛡</span>"
    when "npc"
      id = element.match(/(?<=id=")[^"]+/).to_s
      npc_name = Page.get_npcs[id]
      "<span class='html_monster btn-link' id='#{id}' data-id='#{id}'>#{_emoji} #{npc_name.downcase}</span>"
    when "map"
      id = element.match(/(?<=id=")[^"]+/).to_s
      map_name = Page.get_maps[id]
      "<span class='map btn-link' id='#{id}' data-id='#{id}' data-campaign='#{self.book.campaign.id}'>#{_emoji} #{map_name}</span>"
    when "chapter"
      id = element.match(/(?<=id=")[^"]+/).to_s
      chapter = Chapter.find(id)
      "<span class='chapter btn-link' id='#{id}' data-id='#{id}' data-book='#{chapter.book.id}' data-campaign='#{self.book.campaign.id}'>#{_emoji} #{chapter.name}</span>"
    when "hipster"
      "<p>#{hipster}</p>"
    else
      return element
    end
  end

  def emoji(type)
    case type
    when "Monster"
      return "🐉 "
    when "Spell"
      return "📖"
    when "MagicItem"
      return "🔮️"
    when "Encounter"
      return "🗡️🛡️"
    when "Map"
      return "📜"
    when "NPC"
      return "👤"
    when "Chapter"
      return "❗"
    when "Side Quest"
      return "❗"
    else
      return ""
    end
  end
end
