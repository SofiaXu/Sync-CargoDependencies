# Sync-CargoDependencies
Sync version of cargo dependencies in workspace
同步工作空间中的 Cargo 依赖版本

## System Requirement
PowerShell 6 or higher

## Usage
1. add `Dependencies.json` in root of workspace 在工作空间根目录添加 `Dependencies.json`
```
{
    "tonic": "0.6",
    "prost": "0.9",
    "config": "0.13",
    "serde_json": "1.0"
}
```
2. Run `Sync-DependenciesVersion.ps1` with PowerShell in root of workspace 在工作空间根目录用 PowerShell 运行 `Sync-DependenciesVersion.ps1`
