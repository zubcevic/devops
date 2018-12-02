print "************* loading project specific dep_app.py ********************"

#------------------------ define parameters -----------------------------------
dep_clusters = ['was.bankingcluster']

dep_applications = [ 'was.ivtapp' ]

dep_dbdrivers = [ 'dbdriver.GLV' ]

dep_jaas = ['jaas.GLV']

#------------------------ start deployment ------------------------------------
AdminTask.createDatasource('DB2_XA_Driver(cells/TestCell/clusters/cluster1|resources.xml#JDBCProvider_1349171666716)', '[-name ds -jndiName jdbc/ds -dataStoreHelperClassName com.ibm.websphere.rsadapter.DB2UniversalDataStoreHelper -containerManagedPersistence true -componentManagedAuthenticationAlias DmgrTest/GLV -xaRecoveryAuthAlias DmgrTest/GLV -configureResourceProperties [[databaseName java.lang.String mydb] [driverType java.lang.Integer 4] [serverName java.lang.String myserver] [portNumber java.lang.Integer 50000]]]')
AdminConfig.create('MappingModule', '(cells/TestCell/clusters/cluster1|resources.xml#DataSource_1349172600506)', '[[authDataAlias DmgrTest/GLV] [mappingConfigAlias DefaultPrincipalMapping]]')
AdminConfig.modify('(cells/TestCell/clusters/cluster1|resources.xml#CMPConnectorFactory_1349172600608)', '[[name "ds_CF"] [authDataAlias "DmgrTest/GLV"] [xaRecoveryAuthAlias "DmgrTest/GLV"]]')
AdminConfig.create('MappingModule', '(cells/TestCell/clusters/cluster1|resources.xml#CMPConnectorFactory_1349172600608)', '[[authDataAlias DmgrTest/GLV] [mappingConfigAlias DefaultPrincipalMapping]]') 