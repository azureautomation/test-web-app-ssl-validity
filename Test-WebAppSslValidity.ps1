<#
.SYNOPSIS
Function which tests validity of your web app SSL certificate.

.DESCRIPTION
Function which tests validity of your web app SSL certificate and reports if it's valid, expiring or already expired.

.PARAMETER WebApp
Name of the web app that you're targeting.

.PARAMETER ResourceGroup
Name of the resource group where web app resides.

.EXAMPLE
Test-WebAppSslValidity -WebApp corporatetakeaway-prd -ResourceGroup corporatetakeaway-prd-rg

WebApp                SSLSubject             ThumbPrint                      Valid
------                ----------             ----------                      -----
nemanjajovic-prd nemanjajovic.com AD0F1A454817BF3DEE9D4803CF4810346363C3A1   True

.NOTES
General notes
#>

Function Test-WebAppSslValidity {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$WebApp,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroup
    )
    process {
        $CertificateList = (Get-AzWebAppCertificate)
        $UniqueCertificates = $CertificateList | Sort-Object -Property ThumbPrint -Unique
        foreach ($Certificate in $UniqueCertificates) {
            $FindMatch = Get-AzWebAppSSLBinding -WebAppName $WebApp -ResourceGroupName $ResourceGroup | Where-Object {$_.ThumbPrint -eq $Certificate.ThumbPrint}
            if ($FindMatch) {
                $WebAppSsl = [PSCustomObject]@{
                    WebApp = $WebApp
                    SSLSubject = $Certificate.SubjectName
                    ThumbPrint = $Certificate.ThumbPrint
                }
                $Now = [datetime]::Now
                if ($Certificate.ExpirationDate -gt $now.AddDays(+30)) {
                    $WebAppSsl | Add-Member -MemberType NoteProperty -Name 'Valid' -Value $true
                }
                if ($Certificate.ExpirationDate -le $now.AddDays(+30)) {
                    $WebAppSsl | Add-Member -MemberType NoteProperty -Name 'Valid' -Value 'Expiring'
                }
                if ($Certificate.ExpirationDate -le $now) {
                    $WebAppSsl | Add-Member -MemberType NoteProperty -Name 'Valid' -Value $false
                }
                $WebAppSsl
            }
        }
    }
}