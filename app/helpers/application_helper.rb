module ApplicationHelper
  def stat_to_mod(stat)
    mod = ((stat - 10)/2).floor
    mod < 0 ? "-#{mod}" : "+#{mod}"
  end

  def toggle_edit_mode_text(edit_mode)
    edit_mode ? "#{'<i class="material-icons">clear</i>'} Leave Edit Mode" : "#{'<i class="material-icons">edit</i>'}Enter Edit Mode"
  end

  def on_room_page(url)
    if url =~ /rooms\/\S{6}/
      return url =~ /rooms\/\S{6}/
    else
      return url =~ /campaigns\//
    end
  end

  def current_character
    return nil if session[:character_id].nil?
    @character ||= Character.find(session[:character_id])
  end
end
