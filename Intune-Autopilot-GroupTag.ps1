<#
.SYNOPSIS
    Changes a device assigned Group Tag in the Autopilot service
.DESCRIPTION
    It is a sometimes required to change a large quantity of devices' group tags after a reseller has uploaded the CSV to Autopilot
    Because the WindowsAutoPilotIntune set and get commands each use id or serial number exclusively, we must obtain the device id from the object using the serial number
.NOTES
    
.LINK
    
.EXAMPLE 
#>
Install-module WindowsAutopilotIntune -force -AllowClobber
Connect-mgGraph -Scopes "User.ReadWrite.All", "Group.ReadWrite.All", "Directory.ReadWrite.All"
$grouptag = "UserDeploy"
Import-csv Serials.csv | foreach { 
	    $deviceSerial = $_.Serial 
    $computerobject = get-autopilotdevice -serial $deviceSerial
    $id = $computerobject.id
        try{
            set-autopilotdevice -id $id -groupTag $grouptag
            Write-Host "Group Tag $($grouptag) was added to $($deviceSerial)"
        }catch{
            Write-Host "Unable to set group tag $($grouptag) for $($deviceSerial)" -ForegroundColor "Red"
            continue
        }
    }
