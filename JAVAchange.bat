@echo off
setlocal enabledelayedexpansion

REM 检查是否以管理员身份运行
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo 此脚本需要以管理员身份运行，请右键点击并选择“以管理员身份运行”。
    pause
    exit /b 1
)

REM 获取当前JAVA_HOME环境变量的值（如果已设置）
set "currentJavaHome="
for /f "tokens=2 delims==" %%i in ('set JAVA_HOME') do (
    set "currentJavaHome=%%i"
)

REM 如果当前JAVA_HOME有值，输出当前指向的Java版本路径
if defined currentJavaHome (
    echo 当前JAVA_HOME环境变量指向的Java版本为：%currentJavaHome%
    echo.
) else (
    echo 当前未设置JAVA_HOME环境变量。
    echo.
)

REM 初始化变量
set "javaDirs="
set "count=0"

REM 查找C:\Program Files\Java\目录下的子目录作为可能的Java安装目录
for /d %%i in ("C:\Program Files\Java\*") do (
    set /a count+=1
    set "javaDirs=!javaDirs!%%i "
    echo [!count!] %%i
)

REM 如果没有找到任何Java安装目录，给出提示并退出
if "!javaDirs!"=="" (
    echo 在C:\Program Files\Java\目录下未找到有效的Java安装版本，请检查该目录下的安装情况。
    pause
    exit /b 1
)

REM 提示用户输入序号选择要设置的Java版本
set /p choice="请输入序号以选择要设置的Java版本（输入后按回车键）: "

REM 验证用户输入是否为合法的数字序号
echo %choice%|findstr /r "^[0-9]*$" >nul
if %errorlevel% neq 0 (
    echo 输入无效，请输入正确的数字序号。
    pause
    exit /b 1
)

REM 根据用户选择提取对应的Java目录路径
set "selectedDir="
set "index=0"

REM 使用逗号分隔存储所有路径并选择
set /a choice*=2
for %%i in (%javaDirs%) do (
    set /a index+=1
    if !index! equ %choice% (
        set "selectedDir=%%i"
    )
)

REM 如果选择无效（超出范围），给出提示并退出
if not defined selectedDir (
    echo 无效的选择，退出。
    pause
    exit /b 1
)

REM 提取目录名称（如 jdk-17, jdk-22）
for %%i in (%selectedDir%) do (
    set "finalJavaHome=%%~nxi"
)

REM 拼接完整路径
set "finalJavaHome=C:\Program Files\Java\%finalJavaHome%"

REM 设置JAVA_HOME环境变量
setx JAVA_HOME "%finalJavaHome%" /M

REM 输出提示信息
echo JAVA_HOME环境变量已设置为: %finalJavaHome%
echo 请重新打开命令提示符或其他新的终端窗口以使更改生效。

pause
exit /b
