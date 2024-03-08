@echo off
cls
echo Welcome to TSLM! Here you can experience a offline chatbot! Train it however you wish! And have fun!
pause
cls
echo What would you like to do? here are your options: 1 (Chat) 2 (Code) 3 (Download training data)
set /p input= Choose a number from 1-3
if input == 1 goto chat
if input == 2 goto code
if input == 3 goto down
if input == 4 goto about
:chat
cls
TSLM.BAT

:code
cls
TSLM_codebot.BAT

:down
cls
echo feature not implemented yet! Sorry!
pause
goto menu

:about
cls
echo TSLM is a free, offline, easy to use, and a open source chatbot designed to be easy to use and a easy to train localized chatbot. You can modify the training data however you wish. This chatbot uses BSD clause 3 license. Please visit "https://github.com/Tick-Studios-lab/TickStudiosLanguageModel" for more info!
pause
goto menu