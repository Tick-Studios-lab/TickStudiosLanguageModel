@echo off
setlocal enabledelayedexpansion

REM Define file paths
set "dictionary=dictionary.txt"
set "training_data=thoughts.txt"
set "brain=brain.txt"
set "data=data.txt"

REM Load dictionary into an array
for /f "delims=" %%a in (%dictionary%) do (
    set /a "count+=1"
    set "word[!count!]=%%a"
)

REM Load training data into an array
for /f "delims=" %%a in (%training_data%) do (
    set /a "thought_count+=1"
    set "thought[!thought_count!]=%%a"
)

REM Load other .txt files in the directory as training data
for %%F in (*.txt) do (
    if /i "%%F" neq "thoughts.txt" (
        for /f "delims=" %%a in (%%F) do (
            set /a "thought_count+=1"
            set "thought[!thought_count!]=%%a"
        )
    )
)

REM Load brain into an array
for /f "delims=" %%a in (%brain%) do (
    set /a "brain_count+=1"
    set "brain[!brain_count!]=%%a"
)

REM Function to save brain to file
:save_brain
(for /l %%i in (1,1,%brain_count%) do (
    echo !brain[%%i]!
)) > %brain%

REM Function to save thoughts to file
:save_thought
(for /l %%i in (1,1,%thought_count%) do (
    echo !thought[%%i]!
)) > %training_data%

REM Function to save data to file
:save_data
(for /l %%i in (1,1,%data_count%) do (
    echo !data[%%i]!
)) >> %data%

REM Function to guess words
:guess_words
set "letters="
set /p "user_input=User: "
if /i "%user_input%"=="q" goto :eof

REM Save user input to thoughts
echo User: %user_input% >> %training_data%

REM Display user input
echo User: %user_input%

REM Check if the user is asking about thoughts
if /i "%user_input%"=="What are your thoughts today?" (
    echo Generating thoughts...
    set /a "thought_count+=1"
    set "thought[%thought_count%]=Today is a beautiful day."
    set /a "thought_count+=1"
    set "thought[%thought_count%]=I'm excited about learning new things."
    echo Thoughts generated and saved to %training_data%.
    goto guess_words
)

REM Chat with the bot
call :chat "%user_input%" response

REM Save bot response to thoughts
echo Bot: !response! >> %training_data%

REM Display bot response
echo Bot: !response!

REM Save conversation to brain
if defined brain[%user_input%] (
    set /a "brain_count+=1"
    set "brain[!brain_count!]=%user_input%"
    set /a "brain_count+=1"
    set "brain[!brain_count!]=!response!"
) else (
    set "brain[1]=%user_input%"
    set "brain[2]=!response!"
    set "brain_count=2"
)
call :save_brain

REM Save user input and bot response to data
set /a "data_count+=1"
set "data[%data_count%]=User: %user_input%"
set /a "data_count+=1"
set "data[%data_count%]=Bot: !response!"
call :save_data

goto guess_words

:chat
setlocal
set "phrase=%~1"
set "response=I don't understand."

REM Analyze user input patterns and adjust bot's responses accordingly
if defined brain[%phrase%] (
    set /a "pattern_count=0"
    for /l %%i in (1,1,%brain_count%) do (
        set /a "j=%%i+1"
        if "!brain[%%i]!"=="%phrase%" (
            set /a "pattern_count+=1"
            set "pattern[!pattern_count!]=!brain[!j!]!"
        )
    )
    set "response=!pattern[%random%%pattern_count%]!"
)

:end_chat
endlocal & set "%2=%response%" & exit /b
