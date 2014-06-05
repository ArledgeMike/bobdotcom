$(document).ready(function(){

  $(window).on("scroll", function(){     
    win_loc = $(window).scrollTop();
    last_img = ($('img:last').position().top) - ($('img:last').height());

    if (win_loc >= last_img){
      console.log("we at the bottom!!!!!!!!!!!!!!!!!!");
    }
  });

});
