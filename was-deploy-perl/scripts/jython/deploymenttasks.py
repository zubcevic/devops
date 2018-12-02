print "************* loading deploymenttasks.py ********************"

def saveAndSync():
	print "Saving and synchronising changes"
	AdminConfig.save()
	nodeMembers = AdminConfig.list('Node').split(dep_linesep)
	for aNode in nodeMembers:
		aNodeName = AdminConfig.showAttribute(aNode,'name')
		aNodeObject = "type=NodeSync,node="+aNodeName+",*"
		syncVal = AdminControl.completeObjectName(aNodeObject)
		try:
			AdminControl.invoke(syncVal,'sync')
			print aNodeName + " is synchronised"
		except:
			print ""
		continue
	time.sleep(30)
	return

def getProp(dep_key):
	return dep_project_props.getProperty(dep_key)

def verifyApps(dep_applications):
	
	for anApp in dep_applications:
		lAppName = getProp(anApp+'name')
		anApp_id = AdminConfig.getid('/Deployment:'+lAppName+'/')
		if anApp_id == '':
			print 'app: ',lAppName,' - is NOT installed'
		else:
			print 'app: ',lAppName,' - is installed'

def verifyClusters(dep_clusters):
	
	for aCluster in dep_clusters:
		lClusterName = getProp(aCluster+'.name')
		aCluster_id = AdminConfig.getid('/ServerCluster:'+lClusterName+'/')
		if aCluster_id == '':
			print 'cluster: ',lClusterName,' - is NOT installed'
		else:
			print 'cluster: ',lClusterName,' - is installed'

def verifyDBDrivers(dep_dbdrivers):
	
	for aDBDriver in dep_dbdrivers:
		lDBDriverName = getProp(aDBDriver+'.name')
		lDBDriver_id = AdminConfig.getid('/JDBCProvider:'+lDBDriverName+'/')
		if lDBDriver_id == '':
			print 'DB Driver: ',lDBDriverName,' - is NOT installed'
		else:
			print 'DB Driver: ',lDBDriverName,' - is installed'			
			
def installApps(dep_applications):
	
	try:
		for anApp in dep_applications:
			lAppName = getProp(anApp+'.name')
			lAppFile = getProp(anApp+'.file')
			lAppTarget = getProp(anApp+'.target')
			anApp_id = AdminConfig.getid('/Deployment:'+lAppName+'/')
			if anApp_id == '':
				dep_installoptions = '-noprocessEmbeddedConfig -appname ' + lAppName + ' -cluster '+lAppTarget
				AdminApp.install(lAppFile, dep_installoptions)
				print 'app: ',lAppName,' - successfully deployed'
			else:				
				print lAppName + ' allready exists'
	except:
		print "application install failed",sys.exc_info()
		exitDeploymentTool(1)

	return

def installClusters(dep_clusters):
	
	try:
		for aCluster in dep_clusters:
			lClusterName = getProp(aCluster+'.name')
			aCluster_id = AdminConfig.getid('/ServerCluster:'+lClusterName+'/')
			if aCluster_id == '':
				AdminTask.createCluster('[-clusterConfig [-clusterName %s]]' % lClusterName)
				print 'cluster: ',lClusterName,' - successfully created'
			else:
				print 'cluster: ',lClusterName + ' allready exists'
	except:
		print "cluster creation failed",sys.exc_info()
		exitDeploymentTool(1)

	return
	
def installDBDrivers(dep_dbdrivers):
	
	try:
		for aDBDriver in dep_dbdrivers:
			lDriverName = getProp(aDBDriver+'.name')
			lDriverType = getProp(aDBDriver+'.type')
			lDriverScope= getProp(aDBDriver+'.scope')
			lDriver_id = AdminConfig.getid('/JDBCProvider:'+lDriverName+'/')
			if lDriver_id == '':
				if lDriverType == 'DB2XA':
					AdminTask.createJDBCProvider('[-scope '+lDriverScope+' -databaseType DB2 -providerType "DB2 Universal JDBC Driver Provider" -implementationType "XA data source" -name "'+lDriverName+'" -description "Two-phase commit DB2 JCC provider that supports JDBC 3.0. Data sources that use this provider support the use of XA to perform 2-phase commit processing. Use of driver type 2 on the application server for z/OS is not supported for data sources created under this provider." -classpath [${DB2UNIVERSAL_JDBC_DRIVER_PATH}/db2jcc.jar ${UNIVERSAL_JDBC_DRIVER_PATH}/db2jcc_license_cu.jar ${DB2UNIVERSAL_JDBC_DRIVER_PATH}/db2jcc_license_cisuz.jar ] -nativePath [${DB2UNIVERSAL_JDBC_DRIVER_NATIVEPATH} ] ]') 
					print 'DB driver: ',lDriverName,' - successfully created'
				else:
					print 'DB driver type not supported'
			else:
				print 'DB driver: ',lDriverName,' - allready exists'
	except:
		print "DB driver creation failed",sys.exc_info()
		exitDeploymentTool(1)

	return	
	
def installJAAS(dep_jaas):
	
	try:
		for aJAAS in dep_jaas:
			lJAASAlias = getProp(aJAAS+'.alias')
			lJAASUser = getProp(aJAAS+'.user')
			lJAASPwd = getProp(aJAAS+'.pwd')
			lJAASDesc= getProp(aJAAS+'.desc')
			#lJAAS_id = AdminConfig.getid('/JAASAuthData:'+lJAASAlias+'/')
			#if lJAAS_id == '':
			try:
				AdminTask.createAuthDataEntry('[-alias '+lJAASAlias+' -user '+lJAASUser+' -password '+lJAASPwd+' -description "'+lJAASDesc+'" ]')
				print 'JAAS credential: ',lJAASAlias,' - successfully created'
			except:
				print 'JAAS credential: ',lJAASAlias + ' allready exists'
	except:
		print "JAAS credential creation failed",sys.exc_info()
		exitDeploymentTool(1)

	return	
	
def uninstallJAAS(dep_jaas):
	try:
		for aJAAS in dep_jaas:
			lJAASAlias = getProp(aJAAS+'.alias')
			try:
				AdminTask.deleteAuthDataEntry('[-alias '+lJAASAlias+' ]') 
				print 'JAAS credential: ',lJAASAlias,' - successfully removed'
			except:
				print 'JAAS credential: ',lJAASAlias + ' removal failed'
	except:
		print "JAAS credential removal failed",sys.exc_info()
		exitDeploymentTool(1)

	return	

	
def uninstallApps(dep_applications):
	
	try:
		for anApp in dep_applications:
			lAppName = getProp(anApp+'.name')			
			AdminApp.uninstall(lAppName)
			print "application "+lAppName+" is uninstalled successfully"
	except:
		print "application "+lAppName+" is not uninstalled",sys.exc_info()
	

	return

def uninstallClusters(dep_clusters):
	
	try:
		for aCluster in dep_clusters:
			lClusterName = getProp(aCluster+'.name')
			aCluster_id = AdminConfig.getid('/ServerCluster:'+lClusterName+'/')
			if aCluster_id <> '':
				AdminConfig.remove(aCluster_id)
				print 'cluster: ',lClusterName,' - successfully removed'
	except:
		print "cluster "+lClusterName+" could not be deleted",sys.exc_info()
	

	return
	
def uninstallDBDrivers(dep_dbdrivers):
	
	try:
		for aDBDriver in dep_dbdrivers:
			lDBDriverName = getProp(aDBDriver+'.name')
			lDBDriver_id = AdminConfig.getid('/JDBCProvider:'+lDBDriverName+'/')
			if lDBDriver_id <> '':
				AdminConfig.remove(lDBDriver_id)
				print 'DB Driver: ',lDBDriverName,' - successfully removed'
	except:
		print "DB Driver "+lDBDriverName+" could not be deleted",sys.exc_info()

	
def deployApp(dep_task):
	if dep_task == 'verify':
		verifyApps(dep_applications)
	if dep_task == 'uninstall':
		uninstallApps(dep_applications)
	if dep_task == 'install':
		installApps(dep_applications)
	
def deployCluster(dep_task):
	if dep_task == 'verify':
		verifyClusters(dep_clusters)
	if dep_task == 'uninstall':
		uninstallClusters(dep_clusters)
	if dep_task == 'install':
		installClusters(dep_clusters)

def deployDBDrivers(dep_task):
	if dep_task == 'verify':
		verifyDBDrivers(dep_dbdrivers)
	if dep_task == 'uninstall':
		uninstallDBDrivers(dep_dbdrivers)
	if dep_task == 'install':
		installDBDrivers(dep_dbdrivers)
		
def deployJAAS(dep_task):
	if dep_task == 'verify':
		verifyJAAS(dep_jaas)
	if dep_task == 'uninstall':
		uninstallJAAS(dep_jaas)
	if dep_task == 'install':
		installJAAS(dep_jaas)
