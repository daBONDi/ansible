#!powershell
# (c) 2017, David Baumann <daBONDi@users.noreply.github.com>
# No Licence Defined
#
# WANT_JSON
# POWERSHELL_COMMON

$ErrorActionPreference = 'Stop'

$params = Parse-Args -arguments $args -supports_check_mode $true
$check_mode = Get-AnsibleParam -obj $params -name "_ansible_check_mode" -type "bool" -default $false
$diff_mode = Get-AnsibleParam -obj $params -name "_ansible_diff" -type "bool" -default $false

$package_name = Get-AnsibleParam -obj $params -name "name" -type "str" -failifempty $true
$package_state = Get-AnsibleParam -obj $params -name "state" -type "str" -default "present" -validateset "absent","present"
$package_version = Get-AnsibleParam -obj $params -name "version" -type "str" -default $null
$package_provider = Get-AnsibleParam -obj $params -name "provider" -type "str" -default "nuget"
$package_provider_autoinstall = Get-AnsibleParam -obj $params -name "provider_autoinstall" -type "bool" -default $true

$result = @{
  changed = $false
}

if($diff_mode) {
  $result.dif = @{}
}

Enum PackageStatus {
  Present
  VersionMismatch
  Absent
}

Enum PackageProviderStatus {
  Present
  Absent
}

function Get-PackageProviderStatus(){
  if( (Get-PackageProvider | Where-Object { $_.Name -eq $package_provider }) )
  {
    return [PackageProviderStatus]::Present
  }else{
    return [PackageProviderStatus]::Absent
  }
}

function Get-PackageStatus()
{

    $package_query =  Get-Package | Where-Object { $_.Name -eq $package_name }

  if($package_query){
    if($package_query.version -eq $package_version){
      return [PackageStatus]::Present
    }else{
      return [PackageStatus]::VersionMismatch
    }
  }else{
    return [PackageStatus]::NotPresent
  }
}

$package_provider_status = Get-PackageProviderStatus
$package_status = Get-PackageStatus
$result.pre_status = @{
  provider_status = $package_provider_status
  package_status = $package_status
}
# Catch when Package Provider is not Installed and provider_autoinstall is $false
if($package_provider_status -eq [PackageProviderStatus]::Absent -and $provider_autoinstall -eq $false{
  Fail-Json $result "Package Provider $package_provider is not present on the system and provider_autoinstall is false"
}

# Ensure Package Provider

# Install Package Prov


$result.msg = Get-PackageStatus

# Get Package if it is installed
#$package_query = 

#if(-not $package_query)



Exit-Json -obj $result