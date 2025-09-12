function Update-MSCatalogUpdate {
    param (
        [Parameter(
            Mandatory = $true, 
            Position = 0, 
            ParameterSetName = "Guid",
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true)]
        [String] $Guid,

        [Parameter( 
            Position = 1, 
            ParameterSetName = "Destination")]
        [String] $Destination = "C:\\Temp\\TEST"
    )
    Process {
        
        
        $Links = Get-UpdateLinks -Guid $Guid
        if (-not $Links) {
            return
        }

        $CleanOutFile = $Guid + ".json"

        $outfile = Join-Path -Path $Destination -ChildPath $CleanOutFile

        # $ProgressPreference = 'SilentlyContinue'

        # Initialize update request
        $Uri = "https://www.catalog.update.microsoft.com/ScopedViewInline.aspx?updateid=$Guid"
        $Res = Invoke-UpdateRequest -Uri $Uri

        foreach ($Link in $Links) {
            $Res.Link.Add($Link.URL)
        }    

        $Res | Convert-ForJson | ConvertTo-Json | Out-File $outfile
    }    
}