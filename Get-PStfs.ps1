######################################################################################
# Script NAme: Get-PStfs.ps1                                                         #
# Released:    April-14-2016                                                         #
# Version:     1.0.0                                                                 #
# Author:      Richie Jing                                                           #
# Requires:    Visual Studio 2012 or higher version                                  #
#              Microsoft Visual Studio Team Foundation Server Power Tools            #
#              Mysql .NET connector                                                  #
# Description: Query TFS api, insert into MySQL database for management              #
#                                                                                    #
######################################################################################

# Import base class that the main application depends to run
. "$env:HOMEPATH\Documents\GitHub\PStfs_management\BaseClass.ps1"

[string]$tfsCollectionUrl = "http://10.20.201.160:8080/tfs/DefaultCollection"
$ws                       = new-TFSconnection -tfsUrl $tfsCollectionUrl
#$startDate= (get-lastweek)[0] 
#$EndDate= (get-currentweek)[1]
# Query all the Platform team's Change tickets
$query                    = "SELECT [System.Id], [System.Title] FROM WorkItems " +
                            "WHERE [Property Group] = 'Platform Services' " +
                            #"WHERE [Property Group] = 'Network' " +
                            "AND [Work Item Type] = 'Change'" +
                            #"AND [Status] <> 'Canceled'" +
                            #"AND [Status] <> 'Rejected'" +
                            #"AND [Scheduled Start Date] > '$startDate'" +
                            #"AND [Scheduled Start Date] < '$EndDate'" +
                            "ORDER BY [System.Id]"

$ParentItems              = $ws.query($query)

#This assembly was provided by mysql .net connector
[void][System.Reflection.Assembly]::LoadWithPartialName("MySql.Data")

$connectionStr = "Server=localhost;Uid=root;Pwd=jingming;database=tfs;pooling=true;min pool size=5;max pool size=512;connect timeout = 20;"
#$querysql = "select * from user;"

$connection = New-Object MySql.Data.MySqlClient.MySqlConnection
$connection.ConnectionString = $connectionStr
$connection.Open()
#$command = New-Object MySql.Data.MySqlClient.MySqlCommand($querysql, $connection)
#$dataAdapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter($command)
#$dataSet = New-Object System.Data.DataSet
#$recordCount = $dataAdapter.Fill($dataSet)
#$dataSet.Tables[0]
#$connection.Close()




#Construct the TFS data into SQL querycommand
$formated_data = Format-TFSdata -ParentWorkItems $ParentItems
$insert=""

ForEach($x in $formated_data)
{

    [system.string]$T_id = $x.Id
    [system.string]$T_title = Replace-SingleQuote -text $x.Title
    [system.string]$T_Description = Format-Justification -T_Justification $x.'Description - 21ViaNet OE Project Change Management System'
    [system.string]$T_Justification = Format-Justification -T_Justification $x.Justification
    [system.string]$T_PreDeployment = Replace-SingleQuote -text $x.'Pre-Deployment'
    [system.string]$T_PostDeployment = Replace-SingleQuote -text $x.'Post-Deployment Actions'
    [system.string]$T_RollbackPlan = Replace-SingleQuote -text $x.'Rollback Plan'
    [system.string]$T_SuccessCriteria = Replace-SingleQuote -text $x.'Success Criteria'
    [system.string]$T_DeploymentMechanism = Replace-SingleQuote -text $x.'Deployment Mechanism'
    [system.string]$T_PotentialImp = Replace-SingleQuote -text $x.'Potential Impact'
    [system.string]$T_ExpectedImp = Replace-SingleQuote -text $x.'Expected Impact'
    [system.string]$T_ScheduledStart = Format-Datetime -time $x.'Scheduled Start Date'
    [system.string]$T_ScheduledEnd =  Format-Datetime -time $x.'Scheduled End Date'
    [system.string]$T_ActualStart = Format-Datetime -time $x.'Actual Start Date'
    [system.string]$T_ActualEnd = Format-Datetime -time $x.'Actual End Date'
    [system.string]$T_Attachment  = '"' + $x.'Attached File Count' +'"'
    [system.string]$T_History  = Replace-SingleQuote -text $x.History

    $insert+= "INSERT INTO Ticket_RFC(T_id,T_title,T_Description,T_Justification,T_PreDeployment,T_PostDeployment,T_RollbackPlan,T_SuccessCriteria,T_DeploymentMechanism,T_PotentialImp,T_ExpectedImp,T_ScheduledStart,T_ScheduledEnd,T_ActualStart,T_ActualEnd,T_Attachment,T_History) VALUES($T_id,$T_title,$T_Description,$T_Justification,$T_PreDeployment,$T_PostDeployment,$T_RollbackPlan,$T_SuccessCriteria,$T_DeploymentMechanism,$T_PotentialImp,$T_ExpectedImp,$T_ScheduledStart,$T_ScheduledEnd,$T_ActualStart,$T_ActualEnd,$T_Attachment,$T_History);"
}

#call mysql object, and insert into Mysql database
$insertcommand = new-object MySql.Data.MySqlClient.MySqlCommand
$insertcommand.Connection = $connection
$insertcommand.CommandText = $insert
$insertcommand.ExecuteNonQuery()

#===============================================================================
# trying to get more properties of the customized objects

$single = $ParentItems[0]
