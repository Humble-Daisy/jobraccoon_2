// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery3
//= require bootstrap-sprockets
//= require jquery_ujs
//= require turbolinks
//= require_tree .

//= require moment
//= require bootstrap-datetimepicker
//= require pickers
$(document).ready(function() {
  $("#delete_swimlane").on("ajax:success", function(e, data, status, xhr) {
//
  }).bind("ajax:error", function(e, xhr, status, error) {
	alert("This column can't be deleted. Please make sure the column is empty first.");
  });

    $('#completed').change(function() {
        if($(this).is(":checked")) {
			$(this).parents('tr').addClass('marked');
		} else {
			$(this).parents('tr').removeClass('marked');
		}
    });

});