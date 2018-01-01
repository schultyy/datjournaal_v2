"use strict";

var $ = require('jquery');
require("phoenix_html");

$.fn.exists = function () {
    return this.length !== 0;
};

$(document).ready(function() {
  var postDetail = $('.post-detail');

  if(!postDetail.exists()) {
    return;
  }
  try {
    var slug = window.location.href.substring(window.location.href.lastIndexOf('/') + 1);
    if(!slug) {
      return;
    }
    var request = new Request('/api/v1/visit/' + slug, {method: 'POST', credentials: 'same-origin'});
    fetch(request);
  }
  catch(err) {
    console.error('could not log visit', err);
  }
});

$(document).ready(function() {
  var newPostContainer = $('.new-post');
  var searchArea = $('.location-search-area');
  var searchButton = $('.location-search-submit');

  $('.new-post .form-group .submit').click(function() {
    $(this).addClass('disabled');
  });

  if (!newPostContainer) {
    return;
  }

  $("input:file").change(function() {
    var files = $(this).prop('files');
    if (files && files.length > 0) {
      var reader = new FileReader();
      reader.onload = function (e) {
        var img = $('<img>');
        img.attr('src', e.target.result);
        $('.image-preview').empty();
        $('.image-preview').append(img);
      };
      reader.readAsDataURL(files[0]);
    }
  });

  $(searchButton).click(function(event) {
    event.preventDefault();
    searchLocation($('.location-search-bar').val());
  });

  var locationSwitch = $('#has-location');
  if (!locationSwitch) {
    return;
  }

  $(locationSwitch).change(function(event) {
    var isChecked = event.target.checked;
    if (isChecked) {
      $(searchArea).show();
      $(searchArea).css({ display: 'block' });
    } else {
      $(searchArea).hide();
      $('#image_post_places_id').val('');
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
    $(container).empty();
    if (resultViews.length === 0) {
      $(container).append("<p>No search results</p>");
    } else {
      resultViews.forEach(function(view) {
        view.render(container);
      });
    }
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
  $(this.domElement).html(this.mainText + "<br />" + this.description);
  $(this.domElement).addClass('search-result');
  $(this.domElement).click(this.onClick.bind(this));
  $(container).append(this.domElement);
};

Location.prototype.onClick = function(event) {
  if (this.deselectCallback) {
    this.deselectCallback();
  }

  $(this.domElement).addClass('selected');
  $('#image_post_places_id').val(this.placesId);
};

Location.prototype.deselect = function() {
  $(this.domElement).removeClass('selected');
};
