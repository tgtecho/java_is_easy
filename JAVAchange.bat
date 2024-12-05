@echo off
setlocal enabledelayedexpansion

REM ����Ƿ��Թ���Ա�������
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo �˽ű���Ҫ�Թ���Ա������У����Ҽ������ѡ���Թ���Ա������С���
    pause
    exit /b 1
)

REM ��ȡ��ǰJAVA_HOME����������ֵ����������ã�
set "currentJavaHome="
for /f "tokens=2 delims==" %%i in ('set JAVA_HOME') do (
    set "currentJavaHome=%%i"
)

REM �����ǰJAVA_HOME��ֵ�������ǰָ���Java�汾·��
if defined currentJavaHome (
    echo ��ǰJAVA_HOME��������ָ���Java�汾Ϊ��%currentJavaHome%
    echo.
) else (
    echo ��ǰδ����JAVA_HOME����������
    echo.
)

REM ��ʼ������
set "javaDirs="
set "count=0"

REM ����C:\Program Files\Java\Ŀ¼�µ���Ŀ¼��Ϊ���ܵ�Java��װĿ¼
for /d %%i in ("C:\Program Files\Java\*") do (
    set /a count+=1
    set "javaDirs=!javaDirs!%%i "
    echo [!count!] %%i
)

REM ���û���ҵ��κ�Java��װĿ¼��������ʾ���˳�
if "!javaDirs!"=="" (
    echo ��C:\Program Files\Java\Ŀ¼��δ�ҵ���Ч��Java��װ�汾�������Ŀ¼�µİ�װ�����
    pause
    exit /b 1
)

REM ��ʾ�û��������ѡ��Ҫ���õ�Java�汾
set /p choice="�����������ѡ��Ҫ���õ�Java�汾������󰴻س�����: "

REM ��֤�û������Ƿ�Ϊ�Ϸ����������
echo %choice%|findstr /r "^[0-9]*$" >nul
if %errorlevel% neq 0 (
    echo ������Ч����������ȷ��������š�
    pause
    exit /b 1
)

REM �����û�ѡ����ȡ��Ӧ��JavaĿ¼·��
set "selectedDir="
set "index=0"

REM ʹ�ö��ŷָ��洢����·����ѡ��
set /a choice*=2
for %%i in (%javaDirs%) do (
    set /a index+=1
    if !index! equ %choice% (
        set "selectedDir=%%i"
    )
)

REM ���ѡ����Ч��������Χ����������ʾ���˳�
if not defined selectedDir (
    echo ��Ч��ѡ���˳���
    pause
    exit /b 1
)

REM ��ȡĿ¼���ƣ��� jdk-17, jdk-22��
for %%i in (%selectedDir%) do (
    set "finalJavaHome=%%~nxi"
)

REM ƴ������·��
set "finalJavaHome=C:\Program Files\Java\%finalJavaHome%"

REM ����JAVA_HOME��������
setx JAVA_HOME "%finalJavaHome%" /M

REM �����ʾ��Ϣ
echo JAVA_HOME��������������Ϊ: %finalJavaHome%
echo �����´�������ʾ���������µ��ն˴�����ʹ������Ч��

pause
exit /b
