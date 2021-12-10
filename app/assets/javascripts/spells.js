function addSpell(elem) {
  hideActiveSpell();
  var spellId = $(elem.target).attr('id');
  var monster = $(`.monster_card .spell[data-id='${spellId}']`).length > 0
  var page = $(`.card-body .spell[data-id='${spellId}']`).length > 0
  if(spellId) {
    $.get('http://localhost:3000/spells/' + spellId + '.js?show=true&monster=' + monster + "&page=" + page)
  }
}

function addMagicItem(elem) {
  hideActiveSpell();
  var id = $(elem.target).attr('id');
  var monster = $(`.monster_card .magic_item[data-id='${id}']`).length > 0
  var page = $(`.card-body .magic_item[data-id='${id}']`).length > 0
  if(id) {
    $.get('http://localhost:3000/magic_items/' + id + '.js?show=true&monster=' + monster + "&page=" + page)
  }
}

function hideActiveSpell() {
  var elem = $('.spell_card')
  var id = elem.data("id")
  if(id) {
    elem.remove();
    $(`.spell[data-id=${id}]`).on("click", addSpell);
  }
}

function hideActiveMagicItem() {
  var elem = $('.spell_card.active')
  var id = elem.data("id")
  elem.remove();
  $(`.spell[data-id=${id}]`).on("click", addMagicItem);
}
