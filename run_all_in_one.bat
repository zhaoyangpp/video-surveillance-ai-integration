:::::::::::::::::::::::::::::::::::::::::::::::::
:: 视频监控危险行为检测系统启动脚本
:: 用于配置并启动全功能系统
:::::::::::::::::::::::::::::::::::::::::::::::::

@echo off
echo 正在启动视频监控危险行为检测系统...
echo.

:: 设置Python路径
set PYTHONPATH=%PYTHONPATH%;%CD%

:: 系统参数配置
set SOURCE=0
set WIDTH=640
set HEIGHT=480
set PROCESS_EVERY=3
set FEATURE_THRESHOLD=80
set AREA_THRESHOLD=0.05
set SAVE_ALERTS=--save_alerts
set OUTPUT_DIR=output
set ALERT_DIR=alerts
set USE_GPU=

:: 检查是否有CUDA支持
python -c "import torch; print(torch.cuda.is_available())" > temp.txt
set /p CUDA_AVAILABLE=<temp.txt
del temp.txt

if "%CUDA_AVAILABLE%"=="True" (
    echo 检测到CUDA支持，启用GPU加速...
    set USE_GPU=--use_gpu
)

:: 启动系统
echo 启动参数:
echo   视频源: %SOURCE%
echo   分辨率: %WIDTH%x%HEIGHT%
echo   GPU加速: %USE_GPU%
echo   特征阈值: %FEATURE_THRESHOLD%
echo   保存告警: %SAVE_ALERTS%
echo.

python src/all_in_one_system.py ^
    --source %SOURCE% ^
    --width %WIDTH% ^
    --height %HEIGHT% ^
    --process_every %PROCESS_EVERY% ^
    --feature_threshold %FEATURE_THRESHOLD% ^
    --area_threshold %AREA_THRESHOLD% ^
    %SAVE_ALERTS% ^
    --output %OUTPUT_DIR% ^
    %USE_GPU%

echo.
echo 系统已退出。按任意键关闭此窗口...
pause > nul
