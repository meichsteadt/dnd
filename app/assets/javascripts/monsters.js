function hideActiveMonsterCard() {
  $("#monster_card").html('')
}

function showMonsterCard(element) {
  var monsterId = $(element.target).data("id")
  $.get(`/monsters/${monsterId}.js?show=true`)
}
