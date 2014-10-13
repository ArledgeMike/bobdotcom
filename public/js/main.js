$(document).ready(function(){
    console.log("today is all about.......emojis.")

    var $container = $('.main_container');
    // initialize
    $container.imagesLoaded(function () {
        console.log("images loaded callback");
        $container.masonry({
            columnWidth: 120,
            itemSelector: '.item'
        });

    });
});

