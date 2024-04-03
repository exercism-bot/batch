@echo off
REM ---------------------------------------------------
REM Clock Unit Testing
REM ---------------------------------------------------

:Main
    REM Initalize result variable
    set "slug=Clock"

    CALL :Initialize

    REM --------------------
    REM Test Case Start \/\/
    REM Resource: https://github.com/exercism/problem-specifications/blob/main/exercises/clock/canonical-data.json
    REM --------------------
    set "expected=08:00"
    set "if_success=Test passed"
    set "if_failed=Test failed: on the hour."
    CALL :Assert "8" "0"

    set "expected=11:09"
    set "if_success=Test passed"
    set "if_failed=Test failed: past the hour."
    CALL :Assert "11" "09"

    set "expected=00:00"
    set "if_success=Test passed"
    set "if_failed=Test failed: midnight is zero hours."
    CALL :Assert "24" "00"

    set "expected=01:00"
    set "if_success=Test passed"
    set "if_failed=Test failed: hour rolls over."
    CALL :Assert "25" "00"

    set "expected=04:00"
    set "if_success=Test passed"
    set "if_failed=Test failed: hour rolls over continuously."
    CALL :Assert "100" "00"

    set "expected=02:00"
    set "if_success=Test passed"
    set "if_failed=Test failed: sixty minutes is next hour."
    CALL :Assert "1" "60"

    set "expected=02:40"
    set "if_success=Test passed"
    set "if_failed=Test failed: minutes roll over."
    CALL :Assert "0" "160"

    set "expected=04:43"
    set "if_success=Test passed"
    set "if_failed=Test failed: minutes roll over continuously."
    CALL :Assert "0" "1723"

    set "expected=03:40"
    set "if_success=Test passed"
    set "if_failed=Test failed: hour and minutes roll over."
    CALL :Assert "25" "160"

    set "expected=11:01"
    set "if_success=Test passed"
    set "if_failed=Test failed: hour and minutes roll over continuously."
    CALL :Assert "201" "3001"

    set "expected=00:00"
    set "if_success=Test passed"
    set "if_failed=Test failed: hour and minutes roll over to exactly midnight."
    CALL :Assert "72" "8640"

    REM NEGATIVE TEST CASES

    set "expected=23:15"
    set "if_success=Test passed"
    set "if_failed=Test failed: negative hour."
    CALL :Assert "-1" "15"

    set "expected=23:00"
    set "if_success=Test passed"
    set "if_failed=Test failed: negative hour rolls over."
    CALL :Assert "-25" "0"

    set "expected=05:00"
    set "if_success=Test passed"
    set "if_failed=Test failed: negative hour rolls over continuously."
    CALL :Assert "-91" "0"

    set "expected=00:20"
    set "if_success=Test passed"
    set "if_failed=Test failed: negative minutes."
    CALL :Assert "1" "-40"

    set "expected=22:20"
    set "if_success=Test passed"
    set "if_failed=Test failed: negative minutes roll over."
    CALL :Assert "1" "-160"

    set "expected=16:40"
    set "if_success=Test passed"
    set "if_failed=Test failed: negative minutes roll over continuously."
    CALL :Assert "1" "-4820"

    set "expected=01:00"
    set "if_success=Test passed"
    set "if_failed=Test failed: negative sixty minutes is previous hour."
    CALL :Assert "2" "-60"

    set "expected=20:20"
    set "if_success=Test passed"
    set "if_failed=Test failed: negative hour and minutes both roll over."
    CALL :Assert "-25" "-160"

    set "expected=22:10"
    set "if_success=Test passed"
    set "if_failed=Test failed: negative hour and minutes both roll over continuously."
    CALL :Assert "-121" "-5810"

    REM TODO: as Future - ADD OTHER TEST CASES LIKE ADD VALUE TEST CASE
    REM https://github.com/exercism/problem-specifications/blob/8b6a412a949d9080b08869156067a16521c4d1ba/exercises/clock/canonical-data.json#L216

    REM --------------------
    REM Test Case End /\/\/\
    REM --------------------

    CALL :ResolveStatus
    exit /b %errorlevel%
REM End of Main

REM ---------------------------------------------------
REM Assert [..Parameters(up to 9)]
REM ---------------------------------------------------
GOTO :End REM Prevents the code below from being executed
:Assert
set "stdout="

REM Run the program and capture the output then delete the file
CALL %slug%.bat %~1 %~2 %~3 %~4 %~5 %~6 %~7 %~8 %~9 > stdout.bin 2>&1
set /p stdout=<stdout.bin
del stdout.bin

REM Check if the result is correct
if "%stdout%" == "%expected%" (
    if defined if_success (
        echo %if_success%

        REM Reset the variable to avoid duplicating the message.
        set "if_success="
        set "if_failed="
    )

    REM If the result is correct, exit with code 0
    set /a successCount+=1
    exit /b 0
) else (
    if defined if_failed (
        echo %if_failed%
        echo Expected: %expected%
        echo Actually: %stdout%

        REM Reset the variable to avoid duplicating the message.
        set "if_success="
        set "if_failed="
    )

    REM If the result is incorrect, exit with code 1
    set /a failCount+=1
    exit /b 1
)
GOTO :EOF REM Go back to the line after the call to :Assert

:Initialize
REM It's for initialize, not about checking empty file
set "successCount=0"
set "failCount=0"
GOTO :EOF REM Go back to the line after the call to :CheckEmptyFile

:ResolveStatus
set "status="
if %failCount% gtr 0 (
    REM status: Fail
    REM message: The test failed.
    exit /b 1

) else (
    REM status: Pass
    exit /b 0
    
)
GOTO :EOF REM Go back to the line after the call to :ExportResultAsJson

:End
