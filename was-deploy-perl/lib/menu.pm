package menu;

use deployment;  
use strict; 
our %dep_project_props;
my  $dep_select;
our $dep_project;
our $dep_env;
our $dep_task;
our $dep_release;							# global variable

sub validateInput {
	my $dep_var = $_[0];
	if ($dep_var eq 'q') { main::exitDeploymentTool(); }
	if ($dep_var eq 'm') { showMenu(); }

}

sub selectProject() {

	showCurrentMenu();
	print "choose deployment project\n";
	$dep_project = getItemFromDir($dep_project,"projects");
	
	validateInput($dep_project);
	
}

sub selectEnvironment() {

	showCurrentMenu();
	print "choose deployment environment\n";
	$dep_env = getItemFromDir($dep_env,"environments");
	validateInput($dep_env);
	
}

sub selectTask() {
	showCurrentMenu();
	
	print "1) install\n";
	print "2) uninstall\n";
	print "3) verify\n";
	print "\n";
	print "select task: ";
	$dep_select = "";
	while ($dep_task eq "") {
		chomp ($dep_select = <STDIN>);
		if ($dep_select eq "1") { $dep_task = "install"; }
		if ($dep_select eq "2") { $dep_task = "uninstall";  }
		if ($dep_select eq '3') { $dep_task = "verify"; }
		validateInput($dep_select);
	}
}

sub selectRelease() {

	showCurrentMenu();
	print "choose release\n";
	$dep_release = getItemFromDir($dep_release,"projects/$dep_project");
	validateInput($dep_release);
	
}




sub showCurrentMenu() {

	system $^O eq 'MSWin32' ? 'cls' : 'clear';
	deployment->showWelcome();
	if (!($dep_project eq "")) { print "Project: $dep_project\n"; }
	if (!($dep_env eq "")) { print "Environment: $dep_env\n"; }
	if (!($dep_task eq "")) { print "Task: $dep_task\n"; }
	if (!($dep_release eq "")) { print "Release: $dep_release\n"; }
	print "\n";

}

sub startDeploymentMenu() {

	alarm(30);
	selectProject();
	eval {
		require "projects/$dep_project/project.pl";
	};
	if ($@ =~/Can't locate/ ) {
		print "The sub project $dep_project does not exist!\n";
		main::exitDeploymentTool();
	}
	selectEnvironment();	
	eval {
		require "environments/$dep_env/env.pl";
	};
	if ($@ =~/Can't locate/ ) {
		print "The environment $dep_env does not exist!\n";
		main::exitDeploymentTool();
	}
	eval {
		open (F,"environments/$dep_env/${dep_project}.properties") or die "failed to open file $!\n";
		foreach my $line (<F>) {
			(my $name, my $val) = split('=',$line);
			$dep_project_props{$name} = $val;			
		}
		close (F);
	};
	if ($@ =~/failed/ ) {
		print "No project properties read: environments/$dep_env/${dep_project}.properties\n";
	}
	selectTask();
	selectRelease();
	showCurrentMenu();
	alarm(0);
	startProjectDeployment();
	
}

sub showMenu() {
	
	print "1) Select Project\n";
	print "2) Select Environment\n";
	print "\n";

	$dep_select = "";
	while ($dep_select eq "") {
		chomp ($dep_select = <STDIN>);
		if ($dep_select eq "1") { $dep_project = ""; selectProject(); }
		if ($dep_select eq "2") { $dep_env = ""; selectEnvironment(); }
		if ($dep_select eq 'q') { main::exitDeploymentTool(); }
	}
}

sub showContinue() {
	
	print "Press enter to continue\n";
	print "\n";

	$dep_select = "";
	chomp ($dep_select = <STDIN>);
	
}


sub getItemFromDir() {

	my $dep_var = $_[0];
	my $dep_itemdir = $_[1];
	my $dep_default;
	
	opendir (DIR, "$dep_itemdir");
	my @items = readdir(DIR);
	foreach my $dir (@items) {
		if (-d "$dep_itemdir/$dir") {
			if (!($dir eq ".." or $dir eq "." or $dir eq ".svn")) {
				print "$dir\n";
				$dep_default = $dir;
			}
		}
	}	
	print "select an option (enter for $dep_default):";
	while ($dep_var eq "") {	
		chomp ($dep_select = <STDIN>);
		if ((!($dep_select eq "") and (-d "$dep_itemdir/$dep_select")) or ($dep_select eq "q")
		or ($dep_select eq "m")) {
			$dep_var = $dep_select;
			$dep_select = "";
		} elsif ($dep_select eq "") {
			$dep_var = $dep_default;
		} else {
			$dep_var = "";
		}
	}
	return $dep_var;

}

sub getProp() {
	my $dep_key = $_[1];
	my $val = $dep_project_props{$dep_key};
	$val =~s/\s+$//;	
	return $val;

}

1;