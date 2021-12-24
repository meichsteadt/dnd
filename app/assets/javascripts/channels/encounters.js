//= require cable
//= require_self
//= require_tree .

this.App = {};

App.cable = ActionCable.createConsumer();

App.messages = App.cable.subscriptions.create('EncountersChannel', {
  received: function(data) {
    $(".card-title").html(data["name"]);


    var monster = data["monster"];
    var _id = monster["_id"]["$oid"];
    var currentHealth = monster['current_health'];
    this.updateHealth(_id, currentHealth);
  },

  updateHealth: function(id, health) {
    var tr = $("#monster_row_" + id)
    if(health <= 0 ) {
      tr.addClass('dead');
      tr.find('.hp').text(0);
    }
    else {
      tr.removeClass('dead');
      tr.find('.hp').text(health);
    }
  }
});
