$(document).ready(function() {
  $("#tweet").on("submit", function(e) {
    e.preventDefault();
    $("#response").html("<img src='/css/images/ajax-loader.gif'/><span>Tweeting!</span>");

    var tweet = $("input[name='content']").val();
    var twurl = $(this).attr("action");

    $.get(twurl, {data:tweet}, function(response) {
      //console.log(response);
      $('#response').html(response);
    })
  })
});
