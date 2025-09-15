function Update-MSCatalogUpdate {
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory = $true, 
            Position = 0,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true)]
        [String] $Guid,

        [Parameter(
            Mandatory = $true, 
            Position = 0,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true)]
        [String] $Architecture,

        [Parameter( 
            Mandatory = $true,
            Position = 1)]
        [String] $Path
    )
    Process {
        
        
        $Links = Get-UpdateLinks -Guid $Guid
        if (-not $Links) {
            return
        }

        $CleanOutFile = $Guid + ".json"

        $outfile = Join-Path -Path $Path -ChildPath $CleanOutFile

        # $ProgressPreference = 'SilentlyContinue'
        
        Write-Verbose "`nDownloading manifest: $Guid"

        # Initialize update request
        $Uri = "https://www.catalog.update.microsoft.com/ScopedViewInline.aspx?updateid=$Guid"
        $Res = Invoke-UpdateRequest -Uri $Uri

        Write-Verbose "`nManifest downloaded"

        foreach ($Link in $Links) {
            $Res.Link.Add($Link.URL)
        }    
        
        $Res.Architecture = $Architecture

        Write-Output "`nWriting manifest : $CleanOutFile"

        $Res | Convert-ForJson | ConvertTo-Json | Out-File $outfile
    }    
}