<#
.NOTES
    *****************************************************************************
    ETML
    Nom du script:	DisksSpace.ps1
    Auteur:	Mussa-Siem-Nikolas
    Date:	22.09.2023
 	*****************************************************************************
.SYNOPSIS
	Evaluer le pourcentage libre des disques d�une machine � distance
 	
.DESCRIPTION
    Contr�ler sur une liste de machines � distance le pourcentage d�espace disponible sur les diff�rents disques.
    On d�finira comme param�tres la liste de noms des machines
    Un fichier de log unique devra �tre cr�� pour chaque machine
    Un fichier d�erreur devra aussi �tre cr�e

  	
.PARAMETER MachineName
    Ce pram�tre permet d'avoir le nom de la machine actuelle.
	

.OUTPUTS
    Un fichier de log unique sera cr�er
	Un fichier de d'erreur sera cr�er
	
.EXAMPLE
	.\DisksSpace.ps1 -Param1 Toto -Param2 Titi -Param3 Tutu
	
	R�sultat : par exemple un fichier, une modification, un message d'erreur
	
	
#>


param($MachineName)

###################################################################################################################
# Zone de d�finition des variables et fonctions, avec exemples


###################################################################################################################
# Corps du script

# Obtenez le nom de la machine actuelle
$MachineName = $env:COMPUTERNAME

# Sp�cifiez le chemin complet du fichier journal et du fichier d'erreur
$filePath = "S:\Logs\Fichier.log"
$errorFilePath = "S:\Logs\Erreur.log"

try {
    # Obtenez la date actuelle au format souhait� (par exemple, "yyyy-MM-dd HH:mm:ss")
    $date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    # Cr�ez ou ouvrez le fichier journal en mode ajout (Append)
    Add-Content -Path $filePath -Value "Date : $date"
}
catch {
    # En cas d'erreur, capturez l'erreur et enregistrez-la dans le fichier d'erreur
    $errorMessage = "Erreur � $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') : $($_.Exception.Message)"
    Add-Content -Path $errorFilePath -Value $errorMessage
}




Write-Host "Hello World"
    



