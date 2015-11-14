# Copyright © Microsoft Corporation.  All Rights Reserved.
# This code released under the terms of the 
# Microsoft Public License (MS-PL, http://opensource.org/licenses/ms-pl.html.)
# Sample Code is provided for the purpose of illustration only and is not intended to be used in a production environment. 
# THIS SAMPLE CODE AND ANY RELATED INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, 
# INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE. 
# We grant You a nonexclusive, royalty-free right to use and modify the Sample Code and to reproduce and distribute the object code form of the Sample Code, provided that. 
# You agree: 
# (i) to not use Our name, logo, or trademarks to market Your software product in which the Sample Code is embedded; 
# (ii) to include a valid copyright notice on Your software product in which the Sample Code is embedded; 
# and (iii) to indemnify, hold harmless, and defend Us and Our suppliers from and against any claims or lawsuits, including attorneys’ fees, that arise or result from the use or distribution of the Sample Code 

# This module depends on ADAL https://github.com/AzureAD/azure-activedirectory-library-for-dotnet
# You need to register your application to Azure AD in advance to obtain ClientId.
# This module does not handle any errors. See github site more samples.
# https://github.com/azure-samples?query=active-directory

function Get-ADALAccessToken
{

<#
 .SYNOPSIS
 Acquires OAuth 2.0 AccessToken from Azure Active Directory (AAD)

 .DESCRIPTION
 The Get-AccessToken cmdlet lets you acquire OAuth 2.0 AccessToken from Azure Active Directory (AAD) 
 by using Active Directory Authentication Library (ADAL).

 There are two ways to get AccessToken
 
 1. You can pass UserName and Password to avoid SignIn Prompt.
 2. You can pass RedirectUri to use SignIn prompt.

 If you want to use different credential by using SignIn Prompt, use ForcePromptSignIn.
 Use Get-Help Get-AccessToken -Examples for more detail.

 .PARAMETER AuthorityName
 Azure Active Directory Name or Guid. i.e.)contoso.onmicrosoft.com

 .PARAMETER ClientId
 A registerered ClientId as application to the Azure Active Directory.

 .PARAMETER ResourceId
 A Id of service (resource) to consume.

 .PARAMETER UserName
 A username to login to Azure Active Directory.

 .PARAMETER Password
 A password for UserName

 .PARAMETER RedirectUri
 A registered RedirectUri as application to the Azure Active Directory.

 .PARAMETER ForcePromptSignIn
 Indicate to force prompting for signin in.

 .EXAMPLE
 Get-ADALAccessToken -AuthorityName contoso.onmicrosoft.com -ClientId 8f710b23-d3ea-4dd3-8a0e-c5958a6bc16d -ResourceId https://analysis.windows.net/powerbi/api -RedirectUri $redirectUri

 This example acquire accesstoken by using RedirectUri from contoso.onmicrosoft.com Azure Active Directory for PowerBI service. 
 It will only prompt you to sign in for the first time, or when cache is expired.

 .EXAMPLE
 Get-ADALAccessToken -AuthorityName contoso.onmicrosoft.com -ClientId 8f710b23-d3ea-4dd3-8a0e-c5958a6bc16d -ResourceId https://analysis.windows.net/powerbi/api -RedirectUri $redirectUri -ForcePromptSignIn

 This example acquire accesstoken by using RedirectUri from contoso.onmicrosoft.com Azure Active Directory for PowerBI service.
 It always prompt you to sign in.

  .EXAMPLE
 Get-ADALAccessToken -AuthorityName contoso.onmicrosoft.com -ClientId 8f710b23-d3ea-4dd3-8a0e-c5958a6bc16d -ResourceId https://analysis.windows.net/powerbi/api -UserName user1@contoso.onmicrosoft.com -Password password

 This example acquire accesstoken by using UserName/Password from contoso.onmicrosoft.com Azure Active Directory for PowerBI service. 

#>
    param
    (
        [parameter(Mandatory=$true)]
        [string]$AuthorityName,
        [parameter(Mandatory=$true)]
        [string]$ClientId,
        [parameter(Mandatory=$true)]
        [string]$ResourceId,
        [parameter(Mandatory=$true, ParameterSetName="UserName")]
        [string]$UserName,
        [parameter(Mandatory=$true, ParameterSetName="UserName")]
        [string]$Password,
        [parameter(Mandatory=$true, ParameterSetName="RedirectUri")]
        [string]$RedirectUri,
        [parameter(Mandatory=$false, ParameterSetName="RedirectUri")]
        [switch]$ForcePromptSignIn
    )    
    
    # Authority Format
    $authority = "https://login.windows.net/{0}/" -F $AuthorityName;
    # Create AuthenticationContext
    $authContext = New-Object Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext($authority)
    
    try
    {
        if($RedirectUri -ne '')
        {
            # Create RedirectUri
            $rUri = New-Object System.Uri -ArgumentList $RedirectUri
            # Set PromptBehavior
            if($ForcePromptSignIn)
            {
                $promptBehavior = [Microsoft.IdentityModel.Clients.ActiveDirectory.PromptBehavior]::Always
            }
            else
            {
                $promptBehavior = [Microsoft.IdentityModel.Clients.ActiveDirectory.PromptBehavior]::Auto
            }
            # Get AccessToken
            $authResult = $authContext.AcquireToken($ResourceId, $ClientId, $rUri,$promptBehavior)
        }
        else
        {
            # Create Credential
            $cred = New-Object Microsoft.IdentityModel.Clients.ActiveDirectory.UserCredential($UserName, $Password)
            # Get AccessToken
            $authResult = $authContext.AcquireToken($ResourceId, $ClientId, $cred)
        }
    }
    catch [Microsoft.IdentityModel.Clients.ActiveDirectory.AdalException]
    {
        Write-Error $_
    }
    return $authResult.AccessToken
}

function Clear-ADALAccessTokenCache
{

<#
 .SYNOPSIS
 Clears OAuth 2.0 AccessToken (and RefreshToken) local cache

 .DESCRIPTION
 The Get-AccessToken cmdlet lets you clear OAuth 2.0 AccessToken (and RefreshToken) local cache which acquired by 
 Azure Active Directory Authentication Library (ADAL)

 .PARAMETER AuthorityName
 Azure Active Directory Name or Guid. i.e.)contoso.onmicrosoft.com

 .EXAMPLE
 Clear-ADALAccessTokenCache -AuthorityName contoso.onmicrosoft.com

 This example clear local accesstoken cache for contoso.onmicrosoft.com Azure Active Directory.
#>
    param
    (
        [parameter(Mandatory=$true)]
        [string]$AuthorityName
    )    
    
    # Authority Format
    $authority = "https://login.windows.net/{0}/" -F $AuthorityName;
    # Create AuthenticationContext
    $authContext = New-Object Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext($authority)
    
    $authContext.TokenCache.Clear()

    Write-Verbose "Authentication Token Cache Cleared"
}