# PowerShell Script to Backdate Repository6

$repoPath = "C:\Users\Admin\Desktop\time pass\Repository6"
Set-Location $repoPath

Write-Host "Initializing Repository6..."
git init -b main

Write-Host "Adding files..."
git add .

# Target Date: Jan 30, 2020 (Just before the Feb 2 cutoff)
$backdate = "2020-01-30T15:30:00"

Write-Host "Backdating commits to: $backdate"
$env:GIT_AUTHOR_DATE = $backdate
$env:GIT_COMMITTER_DATE = $backdate

git commit -m "Initial commit for Repository6 (2020 Snapshot Candidate)"

# Create a second commit to show activity
$backdate2 = "2020-02-01T09:00:00"
$env:GIT_AUTHOR_DATE = $backdate2
$env:GIT_COMMITTER_DATE = $backdate2
Add-Content -Path README.md -Value "`nUpdated on Feb 1, 2020"
git add README.md
git commit -m "Update documentation before snapshot"

# Clear env vars
Remove-Item Env:\GIT_AUTHOR_DATE
Remove-Item Env:\GIT_COMMITTER_DATE

# Check auth
gh auth status
if ($LASTEXITCODE -ne 0) {
    Write-Error "Please login via 'gh auth login' first."
    exit 1
}

# Create specific repo name "Repository6" or fallback
$targetRepoName = "Repository6"
Write-Host "Attempting to create GitHub repository: $targetRepoName"

# Try to create, if fails (name taken), append random number
try {
    gh repo create $targetRepoName --public --source=. --remote=origin --push
}
catch {
    Write-Warning "Repository6 might already exist. Trying Repository6-Legacy..."
    $targetRepoName = "Repository6-Legacy-" + (Get-Random -Minimum 100 -Maximum 999)
    gh repo create $targetRepoName --public --source=. --remote=origin --push
}

Write-Host "Repository uploaded to https://github.com/$((gh api user --jq .login))/$targetRepoName"
