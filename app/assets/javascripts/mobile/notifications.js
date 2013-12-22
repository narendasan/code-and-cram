$(document).ready(function() {
  var request_sent = false;

  $('#notifications').click(function() {
    if (!request_sent) {
      request_sent = true;
      var user_id = $(this).data().user;

      $.ajax({
        type: 'POST',
        data: 'user_id=' + user_id,
        dataType: 'html',
        url: window.location.origin + '/notifications/fetch',
        success: function(data) {
          $('#unread-badge').html('');
          $('ul#notification-list').html(data);
        }
      });
    }
  });
});
