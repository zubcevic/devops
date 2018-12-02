package deployment;

our $dep_platform;
our $dep_platform_raw;
our $dep_ext;			# global variable
our $dep_was_dmgrroot;
our $dep_was_dmgrhost;
our $dep_was_dmgrport;
our $dep_username;

use strict;
use warnings::register;							# defines warning category "deployment"
use Config;
use Term::ANSIColor;
use menu;


sub showWelcome() {

	if (!( $^O eq 'MSWin32') ) { print color 'bold white';}
	print "Welcome to the Automated Deployment Tool\n";
	if (!( $^O eq 'MSWin32') ) { print color 'reset';}
	showPlatformInfo();
	print "\n";
}


sub getPlatformInfo() {
$dep_platform_raw = $Config{osname};
if ($dep_platform_raw eq 'MSWin32' ) {
	$dep_platform = 'WIN';
	
}

if ($dep_platform eq 'WIN') {

	$dep_username = $ENV{'USERNAME'};
	$dep_ext = ".bat";
} else {
	
	chomp ($dep_username = `who am i |awk '{print \$1}'`);
	$dep_ext = ".sh";
}
}



sub showPlatformInfo() {

getPlatformInfo();
print "OS type: \t$dep_platform\t$dep_platform_raw\n";
print "Username: \t $dep_username\n";
}

sub getWebSphereVariables() {

	$dep_was_dmgrroot = menu->getProp('dmgr.root');
	$dep_was_dmgrhost = menu->getProp('dmgr.host');
	$dep_was_dmgrport = menu->getProp('dmgr.port');

}

sub deployToWebSphere() {

	getWebSphereVariables();
	
	my $dep_command = "$dep_was_dmgrroot/bin/wsadmin$dep_ext -lang jython -f scripts/jython/deploy.py -conntype SOAP -host $dep_was_dmgrhost -port $dep_was_dmgrport";
	my $dep_params  = " $menu::dep_project $menu::dep_env $menu::dep_release $menu::dep_task";
	print "running: $dep_command\n";
	print "params: $dep_params\n";
	system "$dep_command $dep_params";

}



1;
