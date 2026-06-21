```powershell

$targets = @(

"ollama.exe","ollama app.exe",

"lmstudio.exe","lm studio.exe",

"cursor.exe",

"jan.exe",

"gpt4all.exe",

"koboldcpp.exe","koboldcpp_cu12.exe",

"llamafile.exe",

"pinokio.exe",

"msty.exe",

"localai.exe","local-ai.exe",

"nextchat.exe",

"openwebui.exe",

"anytype.exe",

"oobabooga.exe",

"textgenwebui.exe"

)



$found = @()



Check running processes first
foreach ($proc in (Get-Process -ErrorAction SilentlyContinue)) {

$fname = $proc.Name + ".exe"

foreach ($t in $targets) {

if ($fname -ieq $t) {

$path = try { $proc.MainModule.FileName } catch { "(path unavailable)" }

$found += "$($proc.Name)|$path"

break

}

}

}



Filesystem scan of install directories
$searchPaths = @(

$env:ProgramFiles,

${env:ProgramFiles(x86)},

$env:LOCALAPPDATA,

$env:APPDATA,

"$env:USERPROFILE\AppData\Local\Programs"

)



foreach ($base in $searchPaths) {

if (-not (Test-Path $base -ErrorAction SilentlyContinue)) { continue }

foreach ($t in $targets) {

$hits = Get-ChildItem -Path $base -Filter $t -Recurse -Depth 6 -ErrorAction SilentlyContinue | Select-Object -First 3

foreach ($h in $hits) {

$key = "$($h.BaseName)|$($h.FullName)"

if ($found -notcontains $key) { $found += $key }

}

}

}



if ($found.Count -eq 0) { Write-Output "[No Local AI Binaries Found]"; exit }

foreach ($line in ($found | Sort-Object -Unique)) { Write-Output $line }

```