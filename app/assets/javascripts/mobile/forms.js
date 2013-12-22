$(document).ready(function() {

// BVSD email autocomplete
$(".email_autofill").blur(function() {
  var $email = $(this);
  var old_val = $email.val();
  var test_student = old_val.match(/^[a-z]{2,8}\d{4}$/);
  var test_staff = old_val.match(/^[a-z\-]+\.[a-z\-]+$/);
  if (test_student != null || test_staff != null) {
    var new_val = old_val + "@bvsd.org";
    $email.val(new_val.toLowerCase());
  } else {
    $email.val(old_val.toLowerCase());
  }
});

});
