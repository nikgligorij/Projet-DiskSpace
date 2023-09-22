<#
.NOTES
    *****************************************************************************
    ETML
    Nom du script:	DisksSpace.ps1
    Auteur:	Mussa-Siem-Nikolas
    Date:	22.09.2023
 	*****************************************************************************
.SYNOPSIS
	Evaluer le pourcentage libre des disques d’une machine à distance
 	
.DESCRIPTION
    Contrôler sur une liste de machines à distance le pourcentage d’espace disponible sur les différents disques.
    On définira comme paramètres la liste de noms des machines
    Un fichier de log unique devra être créé pour chaque machine
    Un fichier d’erreur devra aussi être crée

  	
.PARAMETER MachineName
    Ce pramètre permet d'avoir le nom de la machine actuelle.
	

.OUTPUTS
    Un fichier de log unique sera créer
	Un fichier de d'erreur sera créer
	
.EXAMPLE
	.\DisksSpace.ps1 -Param1 Toto -Param2 Titi -Param3 Tutu
	
	Résultat : par exemple un fichier, une modification, un message d'erreur
	
	
#>


param($MachineName)

###################################################################################################################
# Zone de définition des variables et fonctions, avec exemples


###################################################################################################################
# Corps du script

# Obtenez le nom de la machine actuelle
$MachineName = $env:COMPUTERNAME

# Spécifiez le chemin complet du fichier journal et du fichier d'erreur
$filePath = "S:\Logs\Fichier.log"
$errorFilePath = "S:\Logs\Erreur.log"

try {
    # Obtenez la date actuelle au format souhaité (par exemple, "yyyy-MM-dd HH:mm:ss")
    $date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    # Créez ou ouvrez le fichier journal en mode ajout (Append)
    Add-Content -Path $filePath -Value "Date : $date"
}
catch {
    # En cas d'erreur, capturez l'erreur et enregistrez-la dans le fichier d'erreur
    $errorMessage = "Erreur à $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') : $($_.Exception.Message)"
    Add-Content -Path $errorFilePath -Value $errorMessage
}




Write-Host "Hello World"
    



