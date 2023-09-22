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

  	
.PARAMETER Param1
    Description du premier paramètre avec les limites et contraintes
	
.PARAMETER Param2
    Description du deuxième paramètre avec les limites et contraintes
 	
.PARAMETER Param3
    Description du troisième paramètre avec les limites et contraintes

.OUTPUTS
    Un fichier de log unique sera créer
	Un fichier de d'erreur sera créer
	
.EXAMPLE
	.\DisksSpace.ps1 -Param1 Toto -Param2 Titi -Param3 Tutu
	
	Résultat : par exemple un fichier, une modification, un message d'erreur
	
	
#>


param($Param1, $Param2, $Param3)

###################################################################################################################
# Zone de définition des variables et fonctions, avec exemples
# Commentaires pour les variables
$date= Get-Date
$path= "c:\temp"

###################################################################################################################
# Zone de tests comme les paramètres renseignés ou les droits administrateurs

# Affiche l'aide si un ou plusieurs paramètres ne sont par renseignés, "safe guard clauses" permet d'optimiser l'exécution et la lecture des scripts
if(!$Param1 -or !$Param2 -or !$Param3)
{
    Get-Help $MyInvocation.Mycommand.Path
	exit
}

###################################################################################################################
# Corps du script

# Ce que fait le script, ici, afficher un message
Write-Host "coucou"
    



