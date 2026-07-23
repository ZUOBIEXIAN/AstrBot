@echo off
setlocal
chcp 65001 >nul

set "ASTRBOT_DIR=D:\Engineering\AstrBot"

if not exist "%ASTRBOT_DIR%" (
    echo [错误] 未找到 AstrBot 目录：%ASTRBOT_DIR%
    echo 请先确认 AstrBot 是否放在这个路径下。
    pause
    exit /b 1
)

cd /d "%ASTRBOT_DIR%"

where uv >nul 2>nul
if errorlevel 1 (
    echo [错误] 未检测到 uv 命令。
    echo 请先安装 uv，或者手动进入 AstrBot 目录执行启动命令。
    pause
    exit /b 1
)

if not exist ".venv" (
    echo [1/2] 首次启动，正在安装 AstrBot 依赖...
    uv sync
    if errorlevel 1 (
        echo.
        echo [错误] 依赖安装失败，请检查上面的报错信息。
        pause
        exit /b 1
    )
) else (
    echo [1/2] 检测到已有虚拟环境，跳过依赖初始化。
)

echo [2/2] 正在启动 AstrBot...
uv run --no-sync main.py

if errorlevel 1 (
    echo.
    echo [提示] 直接启动失败，正在尝试重新同步依赖后再启动一次...
    uv sync
    if errorlevel 1 (
        echo.
        echo [错误] 重新同步依赖失败，请检查上面的报错信息。
        pause
        exit /b 1
    )

    uv run --no-sync main.py
)

if errorlevel 1 (
    echo.
    echo [错误] AstrBot 启动失败，请检查上面的报错信息。
    pause
    exit /b 1
)

endlocal
