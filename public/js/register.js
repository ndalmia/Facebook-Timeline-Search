function checkregisterstep1()
{
	document.getElementById('registererrormsg').style.display='none';
	if(document.registerform.file1.value == "" || document.registerform.file2.value == "" || document.registerform.file3.value == "" || document.registerform.file4.value == "" || document.registerform.file5.value == "" || document.registerform.file6.value == "" || document.registerform.file7.value == "" || document.registerform.file8.value == "" || document.registerform.file9.value == "" || document.registerform.file10.value == "")
	{
		document.getElementById('registererrormsg').innerHTML = "All Files Must be uploaded.";
		document.getElementById('registererrormsg').style.display='block';
		return false;
	}
	document.getElementById('registererrormsg').style.display='none';
	return true;
}

function checkpassword()
{
	document.getElementById('passworderrormsg').style.display='none';	
	if(document.passwordform.password.value.length<5)
	{
		document.getElementById('passworderrormsg').innerHTML = "Passwords must be atleast 5 characters long.";
		document.getElementById('passworderrormsg').style.display='block';
		return false;
	}
	if(document.passwordform.password.value !=document.passwordform.confirmpassword.value)
	{
		document.getElementById('passworderrormsg').innerHTML = "Passwords don't match.";
		document.getElementById('passworderrormsg').style.display='block';
		return false;
	}
	document.getElementById('passworderrormsg').style.display='none';
	return true;
}