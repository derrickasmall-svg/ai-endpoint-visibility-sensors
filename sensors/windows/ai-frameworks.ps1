$results = @()

# Conda environments (Anaconda / Miniconda)
$condaPaths = @(
    "$env:LOCALAPPDATA\anaconda3",
    "$env:USERPROFILE\anaconda3",
    "$env:ProgramData\anaconda3",
    "$env:LOCALAPPDATA\miniconda3",
    "$env:USERPROFILE\miniconda3",
    "$env:ProgramData\miniconda3",
    "$env:USERPROFILE\AppData\Local\Programs\Python\miniforge3"
)
foreach ($p in $condaPaths) {
    $conda = Join-Path $p "condabin\conda.bat"
    if (Test-Path $conda -ErrorAction SilentlyContinue) {
        $name = if ($p -match "miniconda") { "Miniconda" } else { "Anaconda" }
        $results += "$name|$p"
    }
}

# pip package dist-info scan
$pipPkgs = @{
    "torch"="PyTorch"; "tensorflow"="TensorFlow"; "tensorflow_core"="TensorFlow";
    "transformers"="HuggingFace Transformers"; "keras"="Keras";
    "scikit_learn"="scikit-learn"; "sklearn"="scikit-learn";
    "langchain"="LangChain"; "langchain_core"="LangChain";
    "llama_index"="LlamaIndex"; "llama_cpp_python"="llama-cpp-python";
    "openai"="OpenAI SDK"; "anthropic"="Anthropic SDK";
    "huggingface_hub"="HuggingFace Hub"; "diffusers"="HuggingFace Diffusers";
    "sentence_transformers"="Sentence Transformers"; "accelerate"="HuggingFace Accelerate";
    "datasets"="HuggingFace Datasets"; "peft"="HuggingFace PEFT"
}

$sitePaths = @()
$pythons = Get-ChildItem -Path "$env:LOCALAPPDATA\Programs\Python","$env:ProgramFiles\Python*","$env:APPDATA\Python" -ErrorAction SilentlyContinue -Depth 1 | Where-Object { $_.PSIsContainer }
foreach ($py in $pythons) {
    $sitePaths += Get-ChildItem -Path $py.FullName -Filter "site-packages" -Recurse -Depth 3 -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FullName
}

# Also check conda envs
foreach ($p in $condaPaths) {
    $sp = Join-Path $p "Lib\site-packages"
    if (Test-Path $sp -ErrorAction SilentlyContinue) { $sitePaths += $sp }
}

foreach ($sp in ($sitePaths | Sort-Object -Unique)) {
    foreach ($pkg in $pipPkgs.Keys) {
        $distInfos = Get-ChildItem -Path $sp -Filter "${pkg}-*.dist-info" -ErrorAction SilentlyContinue -Depth 1
        foreach ($di in $distInfos) {
            $ver = if ($di.Name -match "${pkg}-(.+)\.dist-info") { $Matches[1] } else { "unknown" }
            $results += "$($pipPkgs[$pkg])|$ver"
        }
    }
}

if ($results.Count -eq 0) { Write-Output "[No AI Frameworks Found]"; exit }
foreach ($r in ($results | Sort-Object -Unique)) { Write-Output $r }