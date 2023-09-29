param(
    [string]$Path,
    [switch]$Verbose,
    [switch]$Remove,
    [switch]$RemoveQuotes
)

Write-Host "Collecting variables from conf file $Path"
$variables = Select-String -Path $Path -Pattern '^\s*[^\s=#]+=[^\s]+$' -Raw

Write-Host "Variables to be substituted: $variables"

foreach($var in $variables) {
    $keyVal = $var -split '=', 2
    $key = $keyVal[0].Trim()
    Write-Host "Variable to be substituted $key"
}

# Create list variable of file names in which secrets should be substituted
$files = @(
    ".\etc\catalog\adls2.properties.temp",
    ".\etc\catalog\delta.properties.temp",
    ".\conf\metastore-site.xml.temp"
)

Write-Host "Substituting variables for Trino catalogs"
foreach($file in $files){
    Write-Host "Substituting variables for $file"
    $out_file = $file -replace ".{5}$"
    (Get-Content $file) | 
        ForEach-Object { 
            if ($_ -match "\$\{((\w+))\}")
            {
                $_ -replace "\$\{(\w+)\}",$([Environment]::GetEnvironmentVariable($Matches[1]))
            }
            else
            {
                $_
            }
        } | Set-Content $out_file

}