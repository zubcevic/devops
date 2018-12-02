import java
import sys
import time
import os

def exitDeploymentTool(dep_exit):
	print "************* end of wsadmin deployment *********************"
	
	sys.exit(dep_exit)
	
#---------------------------- main --------------------------------------------
print "************* start of wsadmin deployment ********************"

# Reading commandline parameters
try:
	dep_project = sys.argv[0]
	dep_env = sys.argv[1]
	dep_release = sys.argv[2]
	dep_task = sys.argv[3]
except:
	print "missing input parameters"
	exitDeploymentTool(1)

# Printing input parameters
print "project: ", dep_project
print "environment: ", dep_env

try:
	dep_project_props_file = java.io.FileInputStream('environments/'+dep_env+'/'+dep_project+'.properties')
	dep_project_props = java.util.Properties()
	dep_project_props.load(dep_project_props_file)
	dep_xml_props_file = java.io.FileInputStream('projects/'+dep_project+'/'+dep_project+'.xml')
	dep_xml_props = java.util.Properties()
	dep_xml_props.loadFromXML(dep_xml_props_file)
	print "--> ",dep_xml_props.getProperty("was.app")
except:
	print "failed to load property file",sys.exc_info()
	
execfile('scripts/jython/deploymenttasks.py')
dep_prop = getProp('dmgr.root')

print "dmgr.root - ",dep_prop

dep_cell = AdminConfig.list('Cell') 
dep_cellname = AdminConfig.showAttribute(dep_cell,'name')
dep_host = AdminControl.getHost()
dep_linesep = java.lang.System.getProperty('line.seperator')

print "cellname - ",dep_cellname, dep_host

dep_appl_file = 'projects/'+dep_project+'/'+dep_release+'/dep_app.py'
if os.path.exists(dep_appl_file):
	execfile(dep_appl_file)	

deployCluster(dep_task)    
deployApp(dep_task)
deployDBDrivers(dep_task)
deployJAAS(dep_task)
	
if dep_task == 'install' or dep_task == 'uninstall':
	saveAndSync()
	
exitDeploymentTool(0)