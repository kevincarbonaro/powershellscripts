$explorerprocesses = @(Get-WmiObject -Query "Select * FROM Win32_Process WHERE Name='explorer.exe'" -ErrorAction SilentlyContinue)
If ($explorerprocesses.Count -eq 0) {
    $result = "TRUE"
    $resultMessage = "No Interactively logged on users."
}
Else {
    ForEach ($i in $explorerprocesses) {
        $Username = $i.GetOwner().User
        $Domain = $i.GetOwner().Domain
        If ($Username -eq "ckt") {
            $result = "FALSE"
            $resultMessage = ""
            break
        }
        Else {
            $result = "TRUE"
            $resultMessage = "sg\ckt must always be interactively logged on."
        }
    }
}

# Initialize object for response
$obj = @{}

# Prepare response object for CW Automate
$obj.error = $result
$obj.errorMessage = $resultMessage 
$Final = [string]::Join("|",($obj.GetEnumerator() | %{$_.Name + "=" + $_.Value}))

Write-Output $Final

# To read the output of this script in CW Automate
# Function: Variable Set
# Set Type: Split NameValue Parameter
# Parameter: @AllVariables@ or whatever was set