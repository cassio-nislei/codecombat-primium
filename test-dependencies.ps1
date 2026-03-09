# Script para testar e validar todas as dependências
# Executa npm audit, verifica pacotes e testa sintaxe do package.json

param(
    [ValidateSet('validate', 'audit', 'check-packages', 'full-test')]
    [string]$TestType = 'full-test'
)

$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$errorLog = @()
$warningLog = @()

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "CodeCombat Dependency Test Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "[$timestamp] Test Type: $TestType" -ForegroundColor Yellow
Write-Host ""

function Test-PackageJsonSyntax {
    Write-Host "[STEP 1] Validando sintaxe do package.json..." -ForegroundColor Yellow
    
    try {
        $packageJson = Get-Content "$projectRoot\package.json" -Raw | ConvertFrom-Json
        Write-Host "✓ package.json JSON válido" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "✗ Erro no package.json: $_" -ForegroundColor Red
        $errorLog += "package.json JSON inválido: $_"
        return $false
    }
}

function Test-NpmAudit {
    Write-Host ""
    Write-Host "[STEP 2] Executando npm audit..." -ForegroundColor Yellow
    
    Set-Location $projectRoot
    
    $auditOutput = npm audit 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Nenhuma vulnerabilidade encontrada" -ForegroundColor Green
    }
    else {
        Write-Host "⚠ Vulnerabilidades encontradas (não crítico)" -ForegroundColor Yellow
        $warningLog += "npm audit reportou vulnerabilidades"
    }
}

function Test-CriticalDependencies {
    Write-Host ""
    Write-Host "[STEP 3] Testando dependências críticas..." -ForegroundColor Yellow
    
    $criticalPackages = @(
        "express",
        "vue",
        "webpack",
        "mongoose",
        "axios",
        "pug",
        "sass-loader",
        "babel-core",
        "lodash",
        "moment"
    )
    
    $packageJson = Get-Content "$projectRoot\package.json" -Raw | ConvertFrom-Json
    $allDeps = @()
    
    # Combinar dependencies e devDependencies
    $packageJson.dependencies.PSObject.Properties | ForEach-Object { $allDeps += $_.Name }
    $packageJson.devDependencies.PSObject.Properties | ForEach-Object { $allDeps += $_.Name }
    
    $missing = @()
    foreach ($pkg in $criticalPackages) {
        if ($allDeps -contains $pkg) {
            Write-Host "  ✓ $pkg" -ForegroundColor Green
        }
        else {
            Write-Host "  ✗ $pkg AUSENTE" -ForegroundColor Red
            $missing += $pkg
        }
    }
    
    if ($missing.Count -gt 0) {
        $errorLog += "Pacotes críticos faltando: $($missing -join ', ')"
        return $false
    }
    
    Write-Host "✓ Todas as dependências críticas encontradas" -ForegroundColor Green
    return $true
}

function Test-RemoteRepositories {
    Write-Host ""
    Write-Host "[STEP 4] Testando acesso a repositórios remotos..." -ForegroundColor Yellow
    
    $repositories = @{
        "npm registry" = "https://registry.npmjs.org/"
        "GitHub API" = "https://api.github.com"
    }
    
    foreach ($repo in $repositories.GetEnumerator()) {
        try {
            $response = Invoke-WebRequest -Uri $repo.Value -Method Head -TimeoutSec 5 -ErrorAction Stop
            Write-Host "  ✓ $($repo.Key)" -ForegroundColor Green
        }
        catch {
            Write-Host "  ✗ $($repo.Key) inacessível" -ForegroundColor Red
            $warningLog += "$($repo.Key) inacessível: $_"
        }
    }
}

function Test-DryRun {
    Write-Host ""
    Write-Host "[STEP 5] Executando npm install --dry-run..." -ForegroundColor Yellow
    
    Set-Location $projectRoot
    
    $dryRunOutput = npm install --dry-run --legacy-peer-deps 2>&1 | Select-Object -Last 20
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Dry-run bem-sucedido" -ForegroundColor Green
        return $true
    }
    else {
        Write-Host "✗ Erro no dry-run:" -ForegroundColor Red
        $dryRunOutput | ForEach-Object { Write-Host "  $_" -ForegroundColor Gray }
        $errorLog += "npm install dry-run falhou"
        return $false
    }
}

function Show-Report {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "RELATÓRIO DE TESTES" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    
    if ($errorLog.Count -gt 0) {
        Write-Host ""
        Write-Host "❌ ERROS ENCONTRADOS:" -ForegroundColor Red
        $errorLog | ForEach-Object { Write-Host "  • $_" }
        return $false
    }
    
    if ($warningLog.Count -gt 0) {
        Write-Host ""
        Write-Host "⚠️  AVISOS:" -ForegroundColor Yellow
        $warningLog | ForEach-Object { Write-Host "  • $_" }
    }
    
    Write-Host ""
    Write-Host "✓ TESTES CONCLUÍDOS COM SUCESSO!" -ForegroundColor Green
    Write-Host "Projeto pronto para npm install" -ForegroundColor Green
    return $true
}

# Executar testes
switch ($TestType) {
    'validate' { 
        if (Test-PackageJsonSyntax) {
            Write-Host "✓ Validação bem-sucedida" -ForegroundColor Green
        }
    }
    'audit' { 
        Test-NpmAudit
    }
    'check-packages' {
        Test-CriticalDependencies
        Test-RemoteRepositories
    }
    'full-test' {
        $syntaxOk = Test-PackageJsonSyntax
        if ($syntaxOk) {
            Test-CriticalDependencies
            Test-RemoteRepositories
            Test-DryRun
        }
    }
}

$success = Show-Report

exit $(if ($success) { 0 } else { 1 })
