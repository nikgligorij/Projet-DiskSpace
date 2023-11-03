<#
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

 

.PARAMETER MachinesName
Ce paramètre permet de spécifier les noms de machine pour lesquels vous souhaitez créer les fichiers de log.

.OUTPUTS
Un fichier de log unique sera créé par machine
Un fichier d'erreur sera créé

 

.EXAMPLE
(avec les droits admin)
.\Y-122-MSN-DiskSpace.ps1 -machinesName DESKTOP-HLVMOLF, DESKTOP-R5VBVBC
    Répertoire : C:\

Mode                 LastWriteTime         Length Name                                           
----                 -------------         ------ ----                                           
d-----        03.11.2023     09:56                logs                                           
Fichier créé : C:\logs\DESKTOP-HLVMOLF.log
Fichier créé : C:\logs\DESKTOP-R5VBVBC.log
Répertoire : C:\logs

Mode                 LastWriteTime         Length Name                                           
----                 -------------         ------ ----                                           
-a----        03.11.2023     09:56              0 DESKTOP-HLVMOLF-Erreur.log                     
-a----        03.11.2023     09:56              0 DESKTOP-R5VBVBC-Erreur.log                     

Résultat : des fichiers de logs seront créés pour toutes les machines du même sous-réseau.

 
.EXAMPLE
.\Y-122-MSN-DiskSpace.ps1 -Subnet 172.20.20 -MachinesName "DESKTOP-HLVMOLF", "DESKTOP-R5VBVBC.local"
Résultat : des fichiers de logs seront créés uniquement pour les machines spécifiées.
#>

# *****************************************************************************
# Params
param(
    [string]$subnet,
    [string[]]$machinesName
)
# *****************************************************************************

# *****************************************************************************
# Global variables
    $logsFolderPath = "C:\logs"

# *****************************************************************************

# *****************************************************************************
# Fonction pour ajouter la date au début d'une ligne de log
function Add-DateToLog {
    param(
        [string]$logFilePath,
        [string]$logMessage
    )

    $date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "$date - $logMessage"
    Add-Content -Path $logFilePath -Value $logEntry
}
#*****************************************************************************

# Obtenez l'adresse IP du système en cours d'exécution
$ipAddress = (Get-NetIPAddress | Where-Object {$_.AddressFamily -eq "IPv4" -and $_.PrefixOrigin -eq "Dhcp"}).IPAddress

# Extrayez le sous-réseau à partir de l'adresse IP
$subnet = $ipAddress.SubnetMaskToString




# Créer le dossier "logs" s'il n'existe pas
if (-not (Test-Path -Path $logsFolderPath -PathType Container)) {
    New-Item -Path $logsFolderPath -ItemType Directory
}

# Si -MachineName est spécifié, utilisez ces noms de machine, sinon, recherchez les machines dans le sous-réseau
if ($machinesName) {
    $foundMachines += $machinesName
}
else {
    # Créez un tableau pour stocker les noms de machines trouvées
    $foundMachines = @()

    # Utilisez le remoting PowerShell pour rechercher des machines sur le même sous-réseau
    $subnetMachines = 1..254 | ForEach-Object { "$subnet.$_" }

    # Parcourez les adresses IP dans le sous-réseau
    foreach ($ip in $subnetMachines) {
        $machinesName = [System.Net.Dns]::GetHostEntry("$subnet.$ip").HostName
        if (Test-Connection -ComputerName $machinesName -Count 1 -Quiet) {
            $foundMachines += $machinesName
            Write-Host "Machine trouvée : $machinesName ($subnet.$ip)"
        }
    }
}

# Parcourir la liste des machines trouvées
foreach ($machinesName in $foundMachines) {
    try {

        # Récupérez les informations sur les disques disponibles sur chaque machine
        $diskInfo = Get-WmiObject -ComputerName $machinesName -Class Win32_LogicalDisk | Select-Object DeviceID, FreeSpace, Size

        # Chemin complet du fichier du pourcentage des disques
        $logFilePath = "C:\logs\$machinesName.log"

        # Parcourir les informations des différents disques et ajouter la date au début de chaque ligne
        foreach ($disk in $diskInfo) {
            $diskName = $disk.DeviceID #Nom du disque
            $freeSpaceGB = [math]::Round($disk.FreeSpace / 1GB, 2) # Espace libre en Go
            $totalSpaceGB = [math]::Round($disk.Size / 1GB, 2)     # Espace total en Go

            # Vérifiez si la taille totale du disque est supérieure à zéro avant de calculer le pourcentage
            if ($totalSpaceGB -gt 0) {
                $freeSpacePercent = [math]::Round(($disk.FreeSpace / $disk.Size) * 100, 2) # Pourcentage d'espace libre
            } else {
                $freeSpacePercent = 0
            }

            Add-DateToLog -LogFilePath $logFilePath -LogMessage "Disque $diskName - Espace libre : ${freeSpaceGB}Go / Espace total : ${totalSpaceGB}Go / Espace libre en pourcentage : ${freeSpacePercent}%"
        }

        Write-Host "Fichier créé : $logFilePath"
    }
    catch {
        # En cas d'erreur, l'erreur est capturée et enregistrée dans un fichier d'erreur
        $errorMessage = "Erreur à $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') sur $machinesName : $($_.Exception.Message)"
        $errorFilePath = "C:\logs\$machinesName-Erreur.log"
        Add-Content -Path $errorFilePath -Value $errorMessage
        Write-Host "Erreur : $errorMessage"
    }
}

# Créez un fichier d'erreur vide pour chaque machine trouvée même si aucune erreur n'a été rencontrée
foreach ($machinesName in $foundMachines) {
    $errorFilePath = "C:\logs\$machinesName-Erreur.log"
    if (!(Test-Path -Path $errorFilePath)) {
        # Si le fichier d'erreur n'existe pas, créez-le
        New-Item -ItemType File -Path $errorFilePath
    }
}
