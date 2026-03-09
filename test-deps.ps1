# Script simples para testar dependências do CodeCombat

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "CodeCombat Dependency Test" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$projectRoot = Get-Location
$errors = 0
$warnings = 0

# Teste 1: Validar JSON
Write-Host "[TEST 1] Validando package.json..." -ForegroundColor Yellow
try {
    $json = Get-Content package.json -Raw | ConvertFrom-Json
    Write-Host "OK - package.json JSON valido" -ForegroundColor Green
} 
catch {
    Write-Host "ERRO - package.json invalido: $_" -ForegroundColor Red
    $errors++
}

# Teste 2: Verificar dependencias criticas
Write-Host ""
Write-Host "[TEST 2] Verificando dependencias criticas..." -ForegroundColor Yellow
$critical = @("express", "vue", "webpack", "mongoose", "axios", "pug", "babel-core")
$deps = $json.dependencies | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name
$devDeps = $json.devDependencies | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name
$allDeps = $deps + $devDeps

foreach ($pkg in $critical) {
    if ($allDeps -contains $pkg) {
        Write-Host "  OK - $pkg encontrado" -ForegroundColor Green
    }
    else {
        Write-Host "  ERRO - $pkg NAO encontrado" -ForegroundColor Red
        $errors++
    }
}

# Teste 3: Conexao com NPM registry
Write-Host ""
Write-Host "[TEST 3] Testando acesso ao NPM registry..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "https://registry.npmjs.org/" -Method Head -TimeoutSec 5 -ErrorAction Stop
    Write-Host "OK - NPM registry acessivel" -ForegroundColor Green
}
catch {
    Write-Host "AVISO - NPM registry pode estar indisponivel" -ForegroundColor Yellow
    $warnings++
}

# Teste 4: npm list (sem instalar)
Write-Host ""
Write-Host "[TEST 4] Executando npm install --dry-run..." -ForegroundColor Yellow
npm install --dry-run --legacy-peer-deps | Out-Null
if ($LASTEXITCODE -eq 0) {
    Write-Host "OK - Simulacao bem-sucedida" -ForegroundColor Green
}
else {
    Write-Host "ERRO - Simulacao falhou" -ForegroundColor Red
    $errors++
}

# Relatorio final
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "RESULTADO" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

if ($errors -eq 0) {
    Write-Host "SUCESSO! Nenhum erro encontrado." -ForegroundColor Green
    if ($warnings -gt 0) {
        Write-Host "Avisos: $warnings" -ForegroundColor Yellow
    }
    Write-Host ""
    Write-Host "Projeto pronto para: npm install --legacy-peer-deps" -ForegroundColor Green
    exit 0
}
else {
    Write-Host "FALHA! Erros encontrados: $errors" -ForegroundColor Red
    Write-Host "Avisos: $warnings" -ForegroundColor Yellow
    exit 1
}
