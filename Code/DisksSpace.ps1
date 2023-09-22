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

  	
.PARAMETER MachineList
    Ce pram�tre permet d'avoir la liste des machines.
	

.OUTPUTS
    Un fichier de log unique sera cr�er
	Un fichier de d'erreur sera cr�er
	
.EXAMPLE
	.\DisksSpace.ps1 -Param1 Toto -Param2 Titi -Param3 Tutu
	
	R�sultat : par exemple un fichier, une modification, un message d'erreur
	
	
#>


param($MachineList)

###################################################################################################################
# Zone de d�finition des variables et fonctions, avec exemples

$date= Get-Date # Variable qui importe la date
$path= "c:\temp" # Variable qui definit un chemin dans le quel on ajoute les diff�rents fichiers de log

###################################################################################################################

# Affiche l'aide si un ou plusieurs param�tres ne sont par renseign�s, "safe guard clauses" permet d'optimiser l'ex�cution et la lecture des scripts
if(!$Param1 -or !$Param2 -or !$Param3)
{
    Get-Help $MyInvocation.Mycommand.Path
	exit
}

###################################################################################################################
# Corps du script

# Ce que fait le script, ici, afficher un message
Write-Host "Hello World"
    



