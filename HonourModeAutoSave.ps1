#Set variables here:
#The location of your BG3 saves directory.
$sourceDirectory = "C:\Users\Jeb_CC\AppData\Local\Larian Studios\Baldur's Gate 3\PlayerProfiles\Public\Savegames\Story"
#The location of where you would like your backups to be stored.
$destinationDirectory = "C:\Users\Jeb_CC\Documents\My Games\Backups\Bg3"
#How often the script should check if BG3 is running, and how often it should backup the saves.
$checkPeriodInSeconds = 300
#Whether you're using Vulkan or not. $true for yes, $false for no (DirectX 11).
$apiVulkan = $false

#Convert the true/false values to .exe file names. Don't add the .exe as it breaks the Get-Process.
if ($apiVulkan -eq $true) {
    $gameProcess = "bg3"
} else {
    $gameProcess = "bg3_dx11"
}

#Alert that the script is running.
Write-Host "HonourModeAutoSave.ps1 is now running."

#This initial short timer is necessary as it waits for BG3 to launch fully, otherwise the script may not detect it in time and quit out prematurely.
Start-Sleep -Seconds 30
#Detects game initially so that the while loop will run at least once.
$game = Get-Process $gameProcess

while ($game -ne $null) {
    try {
        #If the game process is found... attempt to find the game process.
        Write-Host "$checkPeriodInSeconds seconds have passed. Checking if bg3_dx11.exe is still running..."
        $game = Get-Process $gameProcess -ErrorAction Stop
        #If the Get-Process fails to find the game process, it will error, resulting in the catch to run.
        Write-Host "Game is still running, attempting copy."} 

    catch {
        #As the game is not running, the script will now exit. Uncomment the pause if you wish for the PowerShell window to remain open.
        Write-Host "Game is no longer running, ending script."
        #pause
        Exit
    }

    #Get the current date and time in a sortable format.
    $dateTime = Get-Date -Format "yyyyMMdd_HHmmss"
    #Find all directories including the term "HonourMode".
    $folders = Get-ChildItem -Path $sourceDirectory -Directory | Where-Object { $_.Name -like '*HonourMode' }
    
    #For every matching folder found...
    foreach ($folder in $folders) {
        #Create a destination path variable with the date and time added.
        $destinationPath = Join-Path -Path $destinationDirectory -ChildPath ("{0}_{1}" -f $folder.Name, $dateTime)
        #Then copy the folder to said destination path and alert.
        Copy-Item -Path $folder.FullName -Destination $destinationPath -Recurse
        Write-Host "Saved copy to $destinationPath."
    }
    
    #Wait for some time before making another copy.
    Start-Sleep -Seconds $checkPeriodInSeconds
}
