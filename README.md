# Baldur's Gate 3 Honour Made Automatic Save Backup Script
A script that will automatically backup your Baldur's Gate 3 Honour Mode saves.
![Example of Usage](ScriptExample.png?raw=true "Example of Usage")

I am aware other scripts like this exist already, but I wanted to make one according to my own taste.

This script will automatically backup your game to a specified location every X seconds (configurable). Every X seconds it will also check if the game is running, and if it's not, it will auto close itself.

If you follow the optional instructions below, you can set it up so that the script will automatically run when it detects you've launched BG3, meaning it's completely hands free and you won't forget to run the script.

# Why / "This is cheating!"
Whilst you could use this to save scum, it is not the sole purpose. This script exists because there are a myriad of reasons why you may lose your save due to something unfair or just plain stupid. Reasons include...
1. Save file corruption, either due to the game itself, an untimely blackout, Windows crash, etc.
2. Game bugs or glitches. Exhibit A: https://www.youtube.com/watch?v=Xy9oDBUfSAo
3. Using mods that may inadvertently break your save.
5. Cat walks over keyboard, presses the wrong button, you die.
6. You sneeze, press the wrong button, you die.
7. You get fucking tanked, press the wrong button, you die.
8. Your dumbass friend has a mental breakdown, goes rogue, and kills you.
9. Some people just like to back stuff up, and the destination path can be set to a synced directory such as OneDrive, Google Drive, etc.

I am personally not a fan of games that implement permadeaths, because of the above. If you don't want to use a script like this, you are more than welcome not to.

However, my life is hard enough as it is, thus I am more than happy to use scripts like this.

# Requirements
- Windows
- Baldur's Gate 3

# How To
1. Open the PS1 file using notepad or your editor of choice.
2. You will find four variables at the very beginning of the script. Adjust these according to your needs. This includes... where your BG3 save files are stored, where your backups should go, how often the script should backup the saves, and whether you're using Vulkan or DirectX 11 (default is DirectX 11). Save the file after editing.
4. After you launch BG3, right-click the PS1 file and select "Run with PowerShell".

# Optional (Highly Recommended)
**Source:** https://superuser.com/questions/745318/how-to-start-a-program-when-another-one-is-started

Because humans are forgetful, you may forget to the run the script when you start BG3. This optional resolves that problem by auto starting the script when it detects you have started BG3.

To do this, you ask Windows to start audit logging the start of new processes. You will then create a scheduled task that checks for when the BG3 process starts running, which will run the PowerShell script I have provided.

1. Press WindowsKey + R, and open the following: secpol.msc
2. Navigate to Local Policies -> Audit Policy.
3. Double click "Audit process tracking" and set it to Success. Then OK and close the window.
4. Press WindowsKey + R, and open the following: taskschd.msc
5. Right-click your Task Scheduler Library folder on the left, and select "Create Task..."
6. Give it a name, like "BG3 Honour Mode Auto Saver".
7. In the Triggers tab, add a New trigger.
8. Set the trigger to begin the task "On an event", then select Custom, then "Edit Event Filter..."
9. In the XML header, paste the following: 
```
<QueryList>
  <Query Id="0" Path="Security">
    <Select Path="Security">*[System[Provider[@Name='Microsoft-Windows-Security-Auditing'] and Task = 13312 and (band(Keywords,9007199254740992)) and (EventID=4688)]] and *[EventData[Data[@Name='NewProcessName'] and (Data='C:\Program Files (x86)\Steam\steamapps\common\Baldurs Gate 3\bin\bg3_dx11.exe')]]</Select>
  </Query>
</QueryList>
```
10. If you are using Vulkan for your api, change "bg3_dx11.exe" to "bg3.exe".
11. OK that, then go to the Actions tab, add a New action.
12. Set the Action to "Start a program". The Program/script should be: ```C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe```
13. Set the "Add arguments (optional):" to the following, ensuring you change it to reflect wherever you have stored your version of the script.
```PowerShell -file 'C:\Users\Jeb_CC\Documents\My Games\Backups\Bg3\HonourMadeAutoSave.ps1'```
14. OK that. Run BG3. If set up correctly, after you get through the launcher, PowerShell should run with the script you have specified.
