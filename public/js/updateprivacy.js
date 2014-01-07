$(document).ready(function() {
	$("#spinner").bind("ajaxSend", function() {
		$(this).show();
		}).bind("ajaxStop", function() {
		$(this).hide();
		}).bind("ajaxError", function() {
		$(this).hide();
	});
	$('#pform').submit(function(){
		{
			document.getElementById('privacysuccessmsg').style.display='none';
			
			var dataString = 'friends='+document.privacyform.friends.value + '&pending='+ document.privacyform.pending.value  + '&posts=' + document.privacyform.posts.value + '&events=' + document.privacyform.events.value + '&photos=' + document.privacyform.photos.value;
			$.ajax({
				type: "POST",
				url: "/privacy",
				data: dataString,
				success: function(response) {
					if(response=='success'){
						document.getElementById('privacysuccessmsg').style.display='block';
						document.getElementById('privacysuccessmsg').innerHTML = "Privacy Updated Successfully";
					}
					else
					{
						document.getElementById('privacysuccessmsg').style.display='none';
					}
				}
			});
			return false;
		}
	});
});