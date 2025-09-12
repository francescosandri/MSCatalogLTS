class MSUpdateResponse {
    [string] $Title
	[string[]] $Id
	[string] $Architecture
	[string[]] $Language
	[string] $Hotfix
	[string] $Description
	[string] $LastModified
	[string] $Size
	[string[]] $Classification
    [string[]] $SupportedProducts
    [string[]] $MSRCNumber
	[string] $MSRCSeverity
	[string] $RebootBehaviour
	[string] $RequestUserInput
	[string] $ExclusiveInstall
	[string] $NetworkRequired
	[string[]] $UninstallNotes
	[string[]] $UninstallSteps
	[string] $UpdateId
	[string[]] $Supersedes
	[string[]] $SupersededBy
    [System.Collections.Generic.List[string]] $Link
    [string] $InputObject

    MSUpdateResponse($HtmlDoc) {
        $this.Title = $HtmlDoc.GetElementbyId("ScopedViewHandler_titleText").InnerText.Trim()
		
        $divNode = $HtmlDoc.GetElementbyId("kbDiv")
        $spanNode = $divNode.SelectSingleNode(".//span")
        $spanNode.ParentNode.RemoveChild($spanNode)
        $this.Id = ($divNode.InnerText -replace '\r\n\s*,\s*\r\n\s*', ',' -replace '\r\n\s*', '') -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }

        $divNode = $HtmlDoc.GetElementbyId("languagesDiv")
        $spanNode = $divNode.SelectSingleNode(".//span")
        $spanNode.ParentNode.RemoveChild($spanNode)
		$this.Language = ($divNode.InnerText -replace '\r\n\s*,\s*\r\n\s*', ',' -replace '\r\n\s*', '') -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }

		$this.Hotfix = ""
        
		$this.Description = $HtmlDoc.GetElementbyId("ScopedViewHandler_desc").InnerText.Trim()

		$date = [datetime]::parseexact($HtmlDoc.GetElementbyId("ScopedViewHandler_date").InnerText, 'M/d/yyyy', [System.Globalization.CultureInfo]::InvariantCulture)
		$this.LastModified = $date.ToString('yyyy-MM-dd')

		$this.Size = $HtmlDoc.GetElementbyId("ScopedViewHandler_size").InnerText.Trim()

        $divNode = $HtmlDoc.GetElementbyId("classificationDiv")
        $spanNode = $divNode.SelectSingleNode(".//span")
        $spanNode.ParentNode.RemoveChild($spanNode)
		$this.Classification = ($divNode.InnerText -replace '\r\n\s*,\s*\r\n\s*', ',' -replace '\r\n\s*', '') -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }

        $divNode = $HtmlDoc.GetElementbyId("productsDiv")
        $spanNode = $divNode.SelectSingleNode(".//span")
        $spanNode.ParentNode.RemoveChild($spanNode)
		$this.SupportedProducts = ($divNode.InnerText -replace '\r\n\s*,\s*\r\n\s*', ',' -replace '\r\n\s*', '') -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }

        $divNode = $HtmlDoc.GetElementbyId("securityBullitenDiv")
        $spanNode = $divNode.SelectSingleNode(".//span")
        $spanNode.ParentNode.RemoveChild($spanNode)
		$this.MSRCNumber = ($divNode.InnerText -replace '\r\n\s*,\s*\r\n\s*', ',' -replace '\r\n\s*', '') -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }

		$this.MSRCSeverity = $HtmlDoc.GetElementbyId("ScopedViewHandler_msrcSeverity").InnerText.Trim()

		$this.RebootBehaviour = $HtmlDoc.GetElementbyId("ScopedViewHandler_rebootBehavior").InnerText.Trim()

		$this.RequestUserInput = $HtmlDoc.GetElementbyId("ScopedViewHandler_userInput").InnerText.Trim()

		$this.ExclusiveInstall = ""

		$this.NetworkRequired = $HtmlDoc.GetElementbyId("ScopedViewHandler_connectivity").InnerText.Trim()

        $divNode = $HtmlDoc.GetElementbyId("uninstallNotesDiv")
        $spanNode = $divNode.SelectSingleNode(".//span")
        $spanNode.ParentNode.RemoveChild($spanNode)
		$this.UninstallNotes = ($divNode.InnerText -replace '\r\n\s*,\s*\r\n\s*', ',' -replace '\r\n\s*', '') -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }

        $divNode = $HtmlDoc.GetElementbyId("uninstallStepsDiv")
        $spanNode = $divNode.SelectSingleNode(".//span")
        $spanNode.ParentNode.RemoveChild($spanNode)
		$this.UninstallSteps = ($divNode.InnerText -replace '\r\n\s*,\s*\r\n\s*', ',' -replace '\r\n\s*', '') -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }

		$this.UpdateId = $HtmlDoc.GetElementbyId("ScopedViewHandler_UpdateID").InnerText.Trim()

		$this.Supersedes = ($HtmlDoc.GetElementbyId("supersedesInfo").InnerText) -split '\r\n' | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }

		$this.SupersededBy = ($HtmlDoc.GetElementbyId("supersededbyInfo").InnerText) -split '\r\n' | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }

        $this.InputObject = $this.LastModified.Substring(0,7) + " " + $this.SupportedProducts

		$this.Link = [System.Collections.Generic.List[string]]::new()
    }
}