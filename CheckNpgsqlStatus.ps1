# CheckNpgsqlStatus by kenjiuno
# Runs great on Package Manager Console in Visual Studio 2013

# (new-object Net.WebClient).DownloadString("https://raw.githubusercontent.com/kenjiuno/CheckNpgsqlSetupStatus/master/CheckNpgsqlStatus.ps1") | iex

# [System.IO.File]::ReadAllText("H:\Proj\CheckNpgsqlSetupStatus\CheckNpgsqlStatus.ps1")|iex; CheckNpgsqlStatus

function GetProjectProperty
{
    param (
        $project,
        [string] $propertyName,
        [string] $defaultValue
    )
    $ConfigurationManager = $project.ConfigurationManager
    if ($ConfigurationManager) {
        $ActiveConfiguration = $ConfigurationManager.ActiveConfiguration
        if ($ActiveConfiguration) {
            $Properties = $ActiveConfiguration.Properties
            if ($Properties) {
                try {
                    $propertyItem = $Properties.Item($propertyName)
                    if ($propertyItem) {
                        return $propertyItem.Value
                    }
                }
                catch [ArgumentException] {
                    # property not found
                }
            }
        }
    }
    $Properties = $project.Properties
    if ($Properties) {
        try {
            for ($index = 1; $index -le $Properties.Count; $index++) {
                $propertyItem = $Properties[$index]
                if ($propertyItem.Name -ieq $propertyName) {
                    return $propertyItem.Value
                }
            }
        }
        catch [ArgumentException] {
            # property not found
        }
    }
    return $defaultValue
}

function CheckNpgsqlStatus
{
    Write-Host "## DbProviderFactories.GetFactoryClasses" -ForegroundColor Green
    Write-Host "``````" -ForegroundColor DarkGreen
    [System.Data.Common.DbProviderFactories]::GetFactoryClasses() | Out-String -Stream | Write-Host -ForegroundColor DarkGreen
    Write-Host "``````" -ForegroundColor DarkGreen
    
    Write-Host "## GetSection system.data/DbProviderFactories" -ForegroundColor Green
    Write-Host "``````" -ForegroundColor DarkGreen
    [System.Configuration.ConfigurationManager]::GetSection("system.data").Tables["DbProviderFactories"] | Out-String -Stream | Write-Host -ForegroundColor DarkGreen
    Write-Host "``````" -ForegroundColor DarkGreen

    Write-Host "## Npgsql from DbProviderFactories.GetFactory" -ForegroundColor Green
    try {
        $npgsqlAssembly = [System.Data.Common.DbProviderFactories]::GetFactory("Npgsql").GetType().Assembly
        Write-Host " " $npgsqlAssembly.FullName -ForegroundColor DarkGreen
        Write-Host " " $npgsqlAssembly.Location -ForegroundColor DarkGreen
    }
    catch [Exception] {
        Write-Host " " "Not available!" -ForegroundColor Red
    }

    Write-Host "## Npgsql in active project" -ForegroundColor Green
    $found = $false
    $project = Get-Project
    if ($project) {
        $prjKindCSharpProject = $project.Kind -ieq "{FAE04EC0-301F-11D3-BF4B-00C04F79EFBC}"
        $prjKindVBProject = $project.Kind -ieq "{F184B08F-C81C-45F6-A57F-5ABD9991F28F}"
        if ($prjKindCSharpProject -or $prjKindVBProject) {
            $vsproject2 = $project.Object
            if ($vsproject2 -and $vsproject2.References) {
                foreach ($reference in $vsproject2.References) {
                    if ("Npgsql" -ieq $reference.Identity) {
                        $filePathNpgsql = $reference.Path
                        $verNpgsql = [System.Reflection.AssemblyName]::GetAssemblyName($filePathNpgsql).ToString()
                        Write-Host "- Real assembly version:" -ForegroundColor Green
                        Write-Host " " $verNpgsql -ForegroundColor DarkGreen
                        Write-Host " " $reference.Path -ForegroundColor DarkGreen

                        Write-Host "- Actually loaded version where bindingRedirect affects:" -ForegroundColor Green
                        $projectNpgsqlAssembly = [System.Reflection.Assembly]::LoadFile($reference.Path)
                        Write-Host " " $projectNpgsqlAssembly.FullName -ForegroundColor DarkGreen
                        Write-Host " " $projectNpgsqlAssembly.Location -ForegroundColor DarkGreen

                        $found = $true
                    }
                }
            }
            if (-not $found) {
                Write-Host " " "Not found in active project!" -ForegroundColor Red
            }
        }
        else {
            Write-Host " " "No C#/VB.net project!" -ForegroundColor Red
        }
    }
    else {
        Write-Host " " "No active project!" -ForegroundColor Red
    }

    Write-Host "## Npgsql in OutputPath" -ForegroundColor Green
    $found = $false
    $project = Get-Project
    if ($project) {
        $vsproject2 = $project.Object
        if ($vsproject2) {
            $FullPath = $project.Properties.Item("FullPath").Value
            $OutputPath = $project.ConfigurationManager.ActiveConfiguration.Properties.Item("OutputPath").Value
            $filePathNpgsql = Join-Path (Join-Path $FullPath $OutputPath) "Npgsql.dll"
            if (Test-Path $filePathNpgsql) {
                $verNpgsql = [System.Reflection.AssemblyName]::GetAssemblyName($filePathNpgsql).ToString()
                Write-Host "- Real assembly version:" -ForegroundColor Green
                Write-Host " " $verNpgsql -ForegroundColor DarkGreen
                Write-Host " " $filePathNpgsql -ForegroundColor DarkGreen

                Write-Host "- Actually loaded version where bindingRedirect affects:" -ForegroundColor Green
                $projectNpgsqlAssembly = [System.Reflection.Assembly]::LoadFile($filePathNpgsql)
                Write-Host " " $projectNpgsqlAssembly.FullName -ForegroundColor DarkGreen
                Write-Host " " $projectNpgsqlAssembly.Location -ForegroundColor DarkGreen

                $found = $true
            }
            else {
                Write-Host " " "Not found in OutputPath!" -ForegroundColor Red $filePathNpgsql
            }
        }
    }
    else {
        Write-Host " " "No active project!" -ForegroundColor Red
    }

}
