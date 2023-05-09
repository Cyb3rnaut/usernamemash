if ($args.Length -ne 1) {
    Write-Host "usage: $MyInvocation.MyCommand names.txt"
    exit 1
}

if (!(Test-Path $args[0])) {
    Write-Host "$($args[0]) not found"
    exit 1
}

foreach ($line in Get-Content $args[0]) {
    # remove anything in the name that aren't letters or spaces
    $name = $line -replace "[^a-zA-Z\s]", ""
    $tokens = ($name.ToLower() -split "\s+")

    if ($tokens.Length -lt 1) {
        # skip empty lines
        continue
    }

    # assume tokens[0] is the first name
    $fname = $tokens[0]

    # remaining elements in tokens[] must be the last name
    $lname = ""

    if ($tokens.Length -eq 2) {
        # assume traditional first and last name
        # e.g. John Doe
        $lname = $tokens[1]
    }
    elseif ($tokens.Length -gt 2) {
        # assume multi-barrelled surname
        # e.g. Jane van Doe

        # remove the first name
        $tokens = $tokens[1..($tokens.Length - 1)]

        # combine the multi-barrelled surname
        $lname = $tokens -join ""
    }

    # create possible usernames
    Write-Host "${fname}${lname}"
    Write-Host "${lname}${fname}"
    Write-Host "${fname}.${lname}"
    Write-Host "${lname}.${fname}"
    Write-Host "${lname}${fname.Substring(0,1)}"
    Write-Host "${fname.Substring(0,1)}${lname}"
    Write-Host "${lname.Substring(0,1)}${fname}"
    Write-Host "${fname.Substring(0,1)}.${lname}"
    Write-Host "${lname.Substring(0,1)}.${fname}"
    Write-Host "${fname}"
    Write-Host "${lname}"
}
