"use strict";

var $ = require('jquery');

$(document).ready(function() {
  var newPostContainer = $('.new-post');
  var searchBar = $('.location-search-bar');

  if (!newPostContainer) {
    return;
  }

  $(searchBar).keydown(function(event) {
    if (event.keyCode === 13) {
      event.preventDefault();
      searchLocation(event.target.value);
    }
  });

  var locationSwitch = $('#has-location');
  if (!locationSwitch) {
    return;
  }

  $(locationSwitch).change(function(event) {
    var isChecked = event.target.checked;
    if (isChecked) {
      $(searchBar).show();
      $(searchBar).css({ display: 'block' });
    } else {
      $(searchBar).hide();
    }
  });
});


function searchLocation(location) {
  var options = { credentials: "same-origin" };
  fetch("/api/v1/location?location_name=" + encodeURI(location), options)
  .then(function(response) { return response.json();})
  .then(function(results) {
    var resultViews = results.map(function(location) {
      return new Location(location);
    });
    var container = $('.location-results');
    resultViews.forEach(function(view) {
      view.render(container);
    });
  });
}


function Location(locationResult) {
  this.description = locationResult.description;
  this.mainText = locationResult.main_text;
  this.placesId = locationResult.places_id;
}

Location.prototype.render = function(container) {
  var item = $('<div>');
  item.html(this.mainText);
  item.addClass('search-result');
  $(container).append(item);
};
