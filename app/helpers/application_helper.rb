module ApplicationHelper
  def stat_to_mod(stat)
    mod = ((stat - 10)/2).floor
    mod < 0 ? "-#{mod}" : "+#{mod}"
  end

  def toggle_edit_mode_text(edit_mode)
    edit_mode ? "#{'<i class="material-icons">clear</i>'} Leave Edit Mode" : "#{'<i class="material-icons">edit</i>'}Enter Edit Mode"
  end
end
