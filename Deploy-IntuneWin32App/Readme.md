## Intune Win32 Application 

You can use this script to deploy win32 app on the Intune portal. The scripts rely on 3 PowerShell modules.
* Microsoft.Graph.Intune
* IntuneWin32App
* MSAL.PS

# What you need to do:
1. You will need to transform your msi or exe file to intunewin file to use the script.
2. Compose the configuration as the **IntuneWin32App-Config.psd1**.
3. Use the **Deploy-IntuneWin32App.ps1** to deploy it to your Intune environment.  
