function Convert-ForJson {
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [MSUpdateResponse]$Update
    )
    
    process {
        $jsonReady = [PSCustomObject]@{
            Title = $Update.Title
            Id = if ($Update.Id.Count -eq 0) {""} elseif ($Update.Id.Count -eq 1) { $Update.Id[0] } else { $Update.Id }
            Architecture = $Update.Architecture
            Language = if ($Update.Language.Count -eq 0) {""} elseif ($Update.Language.Count -eq 1) { $Update.Language[0] } else { $Update.Language }
            Hotfix = $Update.Hotfix
            Description = $Update.Description
            LastModified = $Update.LastModified
            Size = $Update.Size
            Classification = if ($Update.Classification.Count -eq 0) {""} elseif ($Update.Classification.Count -eq 1) { $Update.Classification[0] } else { $Update.Classification }
            SupportedProducts = if ($Update.SupportedProducts.Count -eq 0) {""} elseif ($Update.SupportedProducts.Count -eq 1) { $Update.SupportedProducts[0] } else { $Update.SupportedProducts }
            MSRCNumber = if ($Update.MSRCNumber.Count -eq 0) {""} elseif ($Update.MSRCNumber.Count -eq 1) { $Update.MSRCNumber[0] } else { $Update.MSRCNumber }
            MSRCSeverity = $Update.MSRCSeverity
            RebootBehaviour = $Update.RebootBehaviour
            RequestUserInput = $Update.RequestUserInput
            ExclusiveInstall = $Update.ExclusiveInstall
            NetworkRequired = $Update.NetworkRequired
            UninstallNotes = if ($Update.UninstallNotes.Count -eq 0) {""} elseif ($Update.UninstallNotes.Count -eq 1) { $Update.UninstallNotes[0] } else { $Update.UninstallNotes }
            UninstallSteps = if ($Update.UninstallSteps.Count -eq 0) {""} elseif ($Update.UninstallSteps.Count -eq 1) { $Update.UninstallSteps[0] } else { $Update.UninstallSteps }
            UpdateId = $Update.UpdateId

            Supersedes = if ($Update.Supersedes.Count -eq 0) {""} 
                            elseif ($Update.Supersedes.Count -eq 1) {
                                if ($Update.Supersedes[0] -match '(KB\d+)') {
                                    [PSCustomObject]@{
                                        KB = $matches[1]
                                        Description = $Update.Supersedes[0]
                                    }
                                }
                            }
                            else {
                                foreach ($KB in $Update.Supersedes) {
                                    if ($KB -match '(KB\d+)') {
                                        [PSCustomObject]@{
                                            KB = $matches[1]
                                            Description = $KB
                                        }
                                    }
                                }
                            }

            SupersededBy =  if ($Update.SupersededBy.Count -eq 0) {""} 
                            elseif ($Update.SupersededBy.Count -eq 1) {
                                if ($Update.SupersededBy[0] -match '(KB\d+)') {
                                    [PSCustomObject]@{
                                        KB = $matches[1]
                                        Description = $Update.SupersededBy[0]
                                    }
                                }
                            }
                            else {
                                foreach ($KB in $Update.SupersededBy) {
                                    if ($KB -match '(KB\d+)') {
                                        [PSCustomObject]@{
                                            KB = $matches[1]
                                            Description = $KB
                                        }
                                    }
                                }
                            }

            Link = $Update.Link
            InputObject = $Update.InputObject
        }
        
        return $jsonReady
    }
}