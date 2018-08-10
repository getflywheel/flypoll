// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require ckeditor/init
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .
var rotated = false;
function showFilters() {
	$("#filter-content").toggle("slow");
	chevron = $("#filter-chevron");
	var chevron = document.getElementById("filter-chevron");
	if(rotated){
		deg = 180;
	}
	else {
		deg = 0;
	}
	chevron.style.webkitTransform = "rotate("+deg+"deg)";
	chevron.style.mozTransform    = 'rotate('+deg+'deg)';
    chevron.style.msTransform     = 'rotate('+deg+'deg)';
    chevron.style.oTransform      = 'rotate('+deg+'deg)';
    chevron.style.transform       = 'rotate('+deg+'deg)';
	rotated = !rotated;	
}
