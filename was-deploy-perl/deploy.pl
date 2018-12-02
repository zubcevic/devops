#!/usr/bin/perl

use strict;
use warnings::register;	
use Term::ANSIColor;
use Getopt::Long;
use Config;
use lib 'lib'; 
use menu;
use warnings "all"; 	# Enable warning messages; equals -w option

our $dep_project_sel;
our $help; 

GetOptions(
	'project=s' => \$dep_project_sel,
	'help|?|h' => \$help
);

sub showTimeOut() {

print "\nYour deployment tool session time out....";
exitDeploymentTool();
 
}


sub exitDeploymentTool() {

print "\nThanks for using the Automated Deployment Tool (c) Rene Zubcevic\n";
exit;

}

if ($help) {
	print "-silent -options <responsefile>\n";
	print colored("-project <project>","yellow","on_black");
	exit;
}



$SIG{INT} = \&exitDeploymentTool;
$SIG{QUIT} = \&exitDeploymentTool;
$SIG{HUP} = \&exitDeploymentTool;
$SIG{ALRM} = \&showTimeOut;

while (1 eq 1) {
	
	menu->startDeploymentMenu();
	
	$menu::dep_task = '';
	menu->showContinue();
	menu->showCurrentMenu();
	#menu->showMenu();
}
