$(document).ready(function() {
	$("#spinner").bind("ajaxSend", function() {
		$(this).show();
		}).bind("ajaxStop", function() {
		$(this).hide();
		}).bind("ajaxError", function() {
		$(this).hide();
	});
	$('#loginform').submit(function(){
		{
			document.getElementById('loginerrormsg').style.display='none';
			
			var dataString = 'user='+ document.loginform.user.value  + '&password=' + document.loginform.password.value;
			$.ajax({
				type: "POST",
				url: "/login",
				data: dataString,
				success: function(response) {
					if(response=='success'){
						document.getElementById('loginerrormsg').style.display='none';
						location.reload();
					}
					else
					{
						document.getElementById('loginerrormsg').innerHTML = response;
						document.getElementById('loginerrormsg').style.display='block';
									document.loginform.user.value='';
			document.loginform.password.value='';
					}
				}
			});
			
			return false;
		}
	});
});