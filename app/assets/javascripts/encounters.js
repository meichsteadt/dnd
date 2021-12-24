function hideActiveEncounterCard() {
  $("#encounter_card").html('');
  $("#encounter_card").removeClass('active');
}

function showEncounter(element) {
  var encounterId = $(element.target).data("id")
  var room = $(element.target).data("room")
  $.get(`/rooms/${room}/encounters/${encounterId}.js`)
}
