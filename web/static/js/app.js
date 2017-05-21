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
      $('#post_places_id').val('');
      $('.location-results').empty();
      $('.location-search-bar').val('');
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
    var locationViewList = new LocationViewList(resultViews);

    var container = $('.location-results');
    resultViews.forEach(function(view) {
      view.render(container);
    });
  });
}

function LocationViewList(childViews) {
  this.childViews = childViews;
  var self = this;
  this.childViews.forEach(function(childView) {
    childView.deselectCallback = self.deselect.bind(self);
  });
}

LocationViewList.prototype.deselect = function() {
  this.childViews.forEach(function(childView) {
    childView.deselect();
  });
};

function Location(locationResult) {
  this.description = locationResult.description;
  this.mainText = locationResult.main_text;
  this.placesId = locationResult.places_id;
}

Location.prototype.render = function(container) {
  this.domElement = $('<div>');
  $(this.domElement).html(this.mainText);
  $(this.domElement).addClass('search-result');
  $(this.domElement).click(this.onClick.bind(this));
  $(container).append(this.domElement);
};

Location.prototype.onClick = function(event) {
  if (this.deselectCallback) {
    this.deselectCallback();
  }

  $(this.domElement).addClass('selected');
  $('#post_places_id').val(this.placesId);
};

Location.prototype.deselect = function() {
  $(this.domElement).removeClass('selected');
};
