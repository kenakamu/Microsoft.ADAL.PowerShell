# Microsoft.ADAL.PowerShell

### Overview 
Microsoft.ADAL.PowerShell module is a wrapper of Azure Active Directory Authentication Library (ADAL) <br/>
Refer to following link for ADAL details.<br/>
https://github.com/AzureAD/azure-activedirectory-library-for-dotnet

**Where do I find the latest relase?**
Releases are found on the [Release Page](https://github.com/kenakamu/Microsoft.ADAL.PowerShell/releases)

###How to setup modules
<p>1. Download Microsoft.ADAL.Powershell.zip.</p> 
<p>2. Right click the downloaded zip file and click "Properties". </p> 
<p>3. Check "Unblock" checkbox and click "OK", or simply click "Unblock" button depending on OS versions. </p> 
![Image of Unblock](https://i1.gallery.technet.s-msft.com/powershell-functions-for-16c5be31/image/file/142582/1/unblock.png)
<p>4. Extract the zip file and copy "Microsoft.ADAL.PowerShell" folder to one of the following folders:<br/>
  * %USERPROFILE%\Documents\WindowsPowerShell\Modules<br/>
  * %WINDIR%\System32\WindowsPowerShell\v1.0\Modules<br/>
<p>5. You may need to change Execution Policy to load the module. You can do so by executing following command. </p> 
```PowerShell
 Set-ExecutionPolicy –ExecutionPolicy RemoteSigned –Scope CurrentUser
```
Please refer to 
[Set-ExecutionPolicy](https://technet.microsoft.com/en-us/library/ee176961.aspx) 
for more information.
<p>6. Open PowerShell and run following command to load the module. </p> 
```PowerShell
# Import Micrsoft.ADAL.Powershell module 
Import-Module Microsoft.ADAL.Powershell
```

####Example 1
This example acquire accesstoken by using RedirectUri from contoso.onmicrosoft.com Azure Active Directory for PowerBI service. It will only prompt you to sign in for the first time, or when cache is expired.
```PowerShell
Get-ADALAccessToken -AuthorityName contoso.onmicrosoft.com `
-ClientId 8f710b23-d3ea-4dd3-8a0e-c5958a6bc16d `
-ResourceId https://analysis.windows.net/powerbi/api `
-RedirectUri $redirectUri
```
####Example 2
This example acquire accesstoken by using RedirectUri from contoso.onmicrosoft.com Azure Active Directory for PowerBI service. It always prompt you to sign in.
```PowerShell
Get-ADALAccessToken -AuthorityName contoso.onmicrosoft.com `
-ClientId 8f710b23-d3ea-4dd3-8a0e-c5958a6bc16d `
-ResourceId https://analysis.windows.net/powerbi/api `
-RedirectUri $redirectUri `
-ForcePromptSignIn
```
####Example 3
This example acquire accesstoken by using UserName/Password from contoso.onmicrosoft.com Azure Active Directory for PowerBI service.
```PowerShell
Get-ADALAccessToken -AuthorityName contoso.onmicrosoft.com `
-ClientId 8f710b23-d3ea-4dd3-8a0e-c5958a6bc16d `
-ResourceId https://analysis.windows.net/powerbi/api `
-UserName user1@contoso.onmicrosoft.com `
-Password password
```
####Example 4
This example clear local accesstoken cache for contoso.onmicrosoft.com Azure Active Directory.
```PowerShell
Clear-ADALAccessTokenCache -AuthorityName contoso.onmicrosoft.com
```
###How to get command details
Each command has detail explanation.
<p>Run following command to get all commands.</p>
```PowerShell
Get-Command -Module Microsoft.ADAL.PowerShell
```
<p>Run following command to get help.</p>
```PowerShell
Get-Help Get-ADALAccessToken -Detailed
```
