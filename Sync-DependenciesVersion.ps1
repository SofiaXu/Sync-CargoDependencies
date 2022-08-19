#Requires -Version 6

$globalDependencies = Get-Content Dependencies.json | ConvertFrom-Json -AsHashtable
$tomlFiles = Get-ChildItem -Recurse Cargo.toml
foreach ($tomlFile in $tomlFiles) {
    $toml = Get-Content $tomlFile -Raw
    $isModified = $false
    Write-Information "Open File $($tomlFile.FullName)"
    [Regex]::Matches($toml, '(?m)([a-zA-Z0-9\-_]+) +?= {0,}(?:\{.+?version {0,}= {0,}"(.+?)".+?\}|"(.+?)")') | ForEach-Object {
        if (-not $globalDependencies.ContainsKey($_.Groups[1].Value)) {
            return
        }
        $version = ""
        $name = $_.Groups[1].Value
        $type = $_.Groups[2].Success
        if ($type) {
            $version = $_.Groups[2].Value
        }
        else {
            $version = $_.Groups[3].Value
        }
        if ($version -ne $globalDependencies[$name]) {
            $isModified = $true
            Write-Information "$name $version -> $($globalDependencies[$name])"
            if ($type) {
                $toml = [Regex]::Replace($toml, "(?m)$name( {0,}= {0,}\{.+?version {0,}= {0,}`")(.+?)(`".+?\})", "$name`${1}$($globalDependencies[$name])`$3")
            }
            else {
                $toml = [Regex]::Replace($toml, "(?m)$name( {0,}= {0,})`"(.+?)`"", "$name = `"$($globalDependencies[$name])`"")
            }
        }
    }
    if ($isModified) {
        Write-Information "Write File $($tomlFile.FullName)"
        $toml | Out-File -LiteralPath $tomlFile.FullName -NoNewline
    }
}
