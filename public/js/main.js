$(document).ready(function(){
  var loc = window.location.href;

  $(window).on("scroll", function(){     
    win_loc = $(window).scrollTop();
    last_img = ($('img:last').position().top) - ($('img:last').height());

    if (win_loc >= last_img){
      $.ajax({
	      url: "http://localhost:4567/30",
	      dataType: "html",
	      success: function(){
	        console.log("we found something here kid");
	      
	      }
      
      });
    }
  });

});
