# Default values
$packageName = 'mingw-linphone-offline'
$packageVersion = '5.3.0'
$rev = 'v4-rev0'
$installDir = "c:\mingw"

$arguments = @{}
$packageParameters = $env:chocolateyPackageParameters

if($packageParameters) {
  $MATCH_PATTERN = "\/(?<option>([a-zA-Z]+)):(?<value>([`"`'])?([a-zA-Z0-9- _\\:\.]+)([`"`'])?)|\/(?<option>([a-zA-Z0-9]+))"
  $option_name = 'option'
  $value_name = 'value'
      
  if($packageParameters -match $MATCH_PATTERN ){
    $results = $packageParameters | Select-String $MATCH_PATTERN -AllMatches
    $results.matches | % {
      $arguments.Add(
        $_.Groups[$option_name].Value.Trim(),
        $_.Groups[$value_name].Value.Trim())        
    }
  }
  
  if($arguments.ContainsKey("path")) {
    $installDir = $arguments["path"]
    Write-Host "Install folder argument found: $installDir"
  }
}

# Select 32-bit or 64-bit install. We're explicit here rather than depending on helpers so we can
# accurately set PATH.
