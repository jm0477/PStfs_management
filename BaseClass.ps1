#Load TFS APIs, and return TFS Server Collection
function New-TFSconnection([string]$tfsUrl)
{
    #Load TFS PowerShell Snap-in
    if ((Get-PSSnapIn -Name Microsoft.TeamFoundation.PowerShell -ErrorAction SilentlyContinue) -eq $null)
    {
        Add-PSSnapin Microsoft.TeamFoundation.PowerShell
    }

    #Load Reference Assemblies
    [void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.TeamFoundation.Client")  
    [void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.TeamFoundation.Build.Client")  
    [void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.TeamFoundation.Build.Common") 
    [void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.TeamFoundation.WorkItemTracking.Client") 
 
    [string] $tfsCollectionUrl = $tfsUrl
    #Get Team Project Collection
    $teamProjectCollection = [Microsoft.TeamFoundation.Client.TfsTeamProjectCollectionFactory]::GetTeamProjectCollection($tfsCollectionUrl)
 
    #Get Work Item Store object
    $ws = $teamProjectCollection.GetService([type]"Microsoft.TeamFoundation.WorkItemTracking.Client.WorkItemStore")
    return $ws

}

# Function will re-format the metadata from TFS, and return a ticket list
function Format-TFSdata($ParentWorkItems)
{
    $result= New-Object 'System.Collections.Generic.List[psobject]'
    foreach($p in $ParentWorkItems)
    {
        $items=$p.Fields
        if($p.links.linktypeend.name -ne 'Parent')
        {
            $o= new-object psobject
            foreach($item in $items)
            {
                $o | add-member -Name $item.name -Type NoteProperty -Value $item.Value
            }
            $result.Add($o)
        } 
    }
    return $result
}




Function Format-Datetime($time)
{
    if($time -ne $null)
    {
         $Ftime = $time
         $Ftime = get-date $time -Format "yyyy-MM-dd HH:mm:ss"
         return "'"+$Ftime+"'"   
    }
    else
    {
        $Ftime = 'NULL'
    }

    return $Ftime
}

Function Format-Justification($T_Justification)
{
    if($T_Justification -ne $null)
    {
        $T_Justification = 0
    }
    else
    {
        $T_Justification = 1
    }
    return  "'" + $T_Justification + "'"
}


Function Replace-SingleQuote([string]$text)
{
    switch ($text)
    {
        {$_ -eq $null -or $_ -eq ""}
        {
            $text = 'NULL'
            return $text
        }
        {$_ -ne $null}
        {
            $text = "'"+ $text.Replace("'","''") + "'"
            return $text
        }
    }
}



Function Filter-Null($text)
{
    if($text -ne $null)
    {
        return $text
    }
    else
    {
        return "NULL"
    }

}