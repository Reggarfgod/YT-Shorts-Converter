$outputFolder = "Converted_Output"

if (!(Test-Path $outputFolder)) {

    New-Item `
    -ItemType Directory `
    -Path $outputFolder | Out-Null
}