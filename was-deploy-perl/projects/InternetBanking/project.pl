print "welcome to the Internet Banking project\n";

sub startProjectDeployment() {
	showProjectMenu()
}

sub showProjectMenu() {
	print "1) deployToWebSphere\n";
	print "\n";
	print "select project task: ";
	$dep_select = "";
	while ($dep_select eq "") {
		chomp ($dep_select = <STDIN>);
		if ($dep_select eq "1") { deployment->deployToWebSphere(); }
		validateInput($dep_select);
	}
	
}