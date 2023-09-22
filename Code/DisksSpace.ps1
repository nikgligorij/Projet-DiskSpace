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

  	
.PARAMETER MachineList
    Ce pramètre permet d'avoir la liste des machines.
	

.OUTPUTS
    Un fichier de log unique sera créer
	Un fichier de d'erreur sera créer
	
.EXAMPLE
	.\DisksSpace.ps1 -Param1 Toto -Param2 Titi -Param3 Tutu
	
	Résultat : par exemple un fichier, une modification, un message d'erreur
	
	
#>


param($MachineList)

###################################################################################################################
# Zone de définition des variables et fonctions, avec exemples

$date= Get-Date # Variable qui importe la date
$path= "c:\temp" # Variable qui definit un chemin dans le quel on ajoute les différents fichiers de log

###################################################################################################################

# Affiche l'aide si un ou plusieurs paramètres ne sont par renseignés, "safe guard clauses" permet d'optimiser l'exécution et la lecture des scripts
if(!$Param1 -or !$Param2 -or !$Param3)
{
    Get-Help $MyInvocation.Mycommand.Path
	exit
}

###################################################################################################################
# Corps du script

# Ce que fait le script, ici, afficher un message
Write-Host "Hello World"
    



