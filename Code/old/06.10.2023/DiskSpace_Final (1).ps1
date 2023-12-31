﻿<#
.NOTES
*****************************************************************************
ETML
Nom du script: DisksSpace.ps1
Auteur: Mussa-Siem-Nikola
Date: 22.09.2023
*****************************************************************************
.SYNOPSIS
Evaluer le pourcentage libre des disques d’une machine à distance

 

 

.DESCRIPTION
Ce script PowerShell permet de contrôler à distance l'espace disque disponible et l'espace disque total sur les disques
d'un groupe de machines. Vous pouvez spécifier les noms de ces machines en tant que paramètres à l'aide de l'option -MachineName.
Le script génère un fichier journal unique pour chaque machine pour stocker ces informations. En cas d'erreurs, il crée également un fichier d'erreur.

 

 

.PARAMETER Subnet
Ce paramètre permet de spécifier le sous-réseau à analyser.

 

.PARAMETER MachineName
Ce paramètre permet de spécifier les noms de machine pour lesquels vous souhaitez créer les fichiers de log.

 

.OUTPUTS
Un fichier de log unique sera créé par machine
Un fichier d'erreur sera créé

 

.EXAMPLE
(avec les droits admin)
.\DisksSpace.ps1 -Subnet 172.20.20
Machine trouvée : DESKTOP-HLVMOLF (172.20.20.2)
Machine trouvée : DESKTOP-R5VBVBC.local (172.20.20.3)
Fichier créé : C:\DESKTOP-HLVMOLF.log
Fichier créé : C:\DESKTOP-R5VBVBC.local.log

 

.EXAMPLE
.\DisksSpace.ps1 -MachineName "DESKTOP-HLVMOLF", "DESKTOP-R5VBVBC.local"
Résultat : des fichiers de logs seront créés uniquement pour les machines spécifiées.

 

#>
param(
    [string]$Subnet,
    [string[]]$MachineName
)

# *****************************************************************************
# Global variables
$date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# *****************************************************************************
 

# Validation du paramètre Subnet
if (-not $Subnet) {
    Write-Host "Veuillez spécifier le sous-réseau avec l'option -Subnet."
    exit 1
}

 

# Si -MachineName est spécifié, utilisez ces noms de machine, sinon, recherchez les machines dans le sous-réseau
if ($MachineName) {
    $foundMachines = $MachineName
}
else {
    # Créez un tableau pour stocker les noms de machines trouvées
    $foundMachines = @()

 

    # Parcourez les 5 premières adresses IP dans le sous-réseau spécifié par l'utilisateur
    for ($i = 1; $i -le 5; $i++) {
        $ip = "$Subnet.$i"
        $pingResult = Test-Connection -ComputerName $ip -Count 1 -ErrorAction SilentlyContinue

 
         # Vérifie si le résultat du ping ($pingResult) n'est pas nulet si le code de statut (StatusCode) est égal à zéro.
        if ($pingResult -ne $null -and $pingResult.StatusCode -eq 0) {
            # Si le ping est réussi (StatusCode 0), ajoutez l'adresse IP à la liste des noms de machines
            $machineName = [System.Net.Dns]::GetHostEntry($ip).HostName
            $foundMachines += $machineName
            Write-Host "Machine trouvée : $machineName ($ip)"
        }
    }
}

 

# Parcourir la liste des machines trouvées
foreach ($machineName in $foundMachines) {
    try {
        # Obtenez la date actuelle au format souhaité
        $date

 

        # Récupérez les informations sur les disques disponibles sur chaque machine
        $diskInfo = Get-WmiObject -ComputerName $machineName -Class Win32_LogicalDisk | Select-Object DeviceID, FreeSpace, Size

 

        # Chemin complet du fichier du pourcentage des disques
        $logFilePath = "C:\$machineName.log"

 

        # Ajout de la date dans le fichier de log
        Add-Content -Path $logFilePath -Value "Date : $date"

 

        # Parcourir les informations des différents disques et ajoutez-les au fichier de log
        foreach ($disk in $diskInfo) {
            $diskName = $disk.DeviceID
            $freeSpaceGB = [math]::Round($disk.FreeSpace / 1GB, 2) # Espace libre en Go
            $totalSpaceGB = [math]::Round($disk.Size / 1GB, 2)     # Espace total en Go
            $freeSpacePercent = [math]::Round(($disk.FreeSpace / $disk.Size) * 100, 2) # Pourcentage d'espace libre
            Add-Content -Path $logFilePath -Value "Disque $diskName - Espace libre : ${freeSpaceGB}Go / Espace total : ${totalSpaceGB}Go / Espace libre en pourcentage : ${freeSpacePercent}%"
        }

 
        # Ecrire que le fichier à été créer avec son nom
        Write-Host "Fichier créé : $logFilePath"
    }
    catch {
        # En cas d'erreur, l'erreur est capturée et enregistrée dans un fichier d'erreur
        $errorMessage = "Erreur à $($date) sur $machineName : $($_.Exception.Message)"
        $errorFilePath = "C:\$machineName-Erreur.log"
        Add-Content -Path $errorFilePath -Value $errorMessage
        Write-Host "Erreur : $errorMessage"
    }
}

 
# Créez un fichier d'erreur vide pour chaque machine trouvée même si aucune erreur n'a été rencontrée
foreach ($machineName in $foundMachines) {
    $errorFilePath = "C:\$machineName-Erreur.log"
    if (!(Test-Path -Path $errorFilePath)) {
        # Si le fichier d'erreur n'existe pas, créez-le
        New-Item -ItemType File -Path $errorFilePath
    }
}