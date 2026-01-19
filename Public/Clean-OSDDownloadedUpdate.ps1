function Clean-OSDDownloadedUpdate {
    Process {
		# Percorso della cartella degli aggiornamenti
		$updatesFolder = "C:\OSDBuilder\Updates"

		# Verifica che la cartella Updates esista
		if (-not (Test-Path $updatesFolder)) {
			Write-Output "ERROR: folder $updatesFolder does not exist!"
			return
		}

		# Array per memorizzare tutti i filename validi
		$validFilenames = @()

		# Ottieni tutti i file JSON nella cartella corrente
		$jsonFiles = Get-ChildItem -Path "." -Filter "*.json" -File

		if ($jsonFiles.Count -eq 0) {
			Write-Output "WARNING: No JSON files found!"
			return
		}

		Write-Verbose "Trovati $($jsonFiles.Count) file JSON nella cartella corrente"

		# Elabora ogni file JSON
		foreach ($jsonFile in $jsonFiles) {
			try {				
				# Leggi il contenuto del file JSON (che in realtà è JSON)
				$content = Get-Content -Path $jsonFile.FullName -Raw | ConvertFrom-Json
				
				# Verifica se esiste la proprietà Link
				if ($content.Link) {
					foreach ($link in $content.Link) {
						# Estrai il filename dall'URL
						$filename = $link.Split('/')[-1]
						
						if ($filename) {
							$validFilenames += $filename
							Write-Verbose "  - Aggiunto: $filename"
						}
					}
				}
			}
			catch {
				Write-Output "ERROR on file $($jsonFile.Name): $_"
			}
		}

		# Rimuovi duplicati
		$validFilenames = $validFilenames | Select-Object -Unique

		Write-Verbose "Files found: $($validFilenames.Count)"

		# Ottieni tutti i file nella cartella Updates
		$filesInUpdates = Get-ChildItem -Path $updatesFolder -File

		Write-Verbose "Files found in $updatesFolder`: $($filesInUpdates.Count)"

		# Controlla quali file devono essere eliminati
		$filesToDelete = @()
		foreach ($file in $filesInUpdates) {
			if ($validFilenames -notcontains $file.Name) {
				$filesToDelete += $file
			}
		}

		if ($filesToDelete.Count -eq 0) {
			Write-Verbose "`nNo file to be deleted"
			return
		}

		# Mostra i file che verranno eliminati
		Write-Verbose "File to delete: $($filesToDelete.Count)"
		foreach ($file in $filesToDelete) {
			Write-Verbose "  - $($file.Name) ($([math]::Round($file.Length / 1MB, 2)) MB)"
		}

   		Write-Verbose "`nDeleting..."
		
		$deletedCount = 0
		$errorCount = 0
			
		foreach ($file in $filesToDelete) {
			try {
				Remove-Item -Path $file.FullName -Force
				Write-Output "Deleted: $($file.Name)"
				$deletedCount++
			}
			catch {
				Write-Output "ERROR deleting $($file.Name): $_"
				$errorCount++
			}
		}
			
		Write-Verbose "Files deleted: $deletedCount"
		if ($errorCount -gt 0) {
			Write-Output "Errors: $errorCount"
		}
    }
}