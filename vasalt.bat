@echo off
REM Vasalt script by IUrixl
REM Original repository on github / Acc: @IUrixl

chcp 65001>nul

setlocal EnableDelayedExpansion
set currentVasaltVersion=1.03b
set CmdOn=false

echo %cmdcmdline%|find /i """%~f0""">nul && goto :cmdInnit || goto :startConsole

:cmdInnit
md runtimeStack
set CmdOn=true
echo VasaltScript - Terminal Version !currentVasaltVersion!
echo Made by IUrixl ^| Original repository on github @IUrixl
echo.

:cmdLines
set/p cmdLinesInput=^> 

echo ^<0x000f^> ^<0x000f^>>>runtimeStack\vars.tmp
echo !cmdLinesInput!>runtimeStack\currentCmdLine.vlt
call :kernel runtimeStack\currentCmdLine.vlt
if !CmdOn!==true ( goto :cmdLines ) else ( goto :breakCmd )

:breakCmd
call :clearFolder runtimeStack\
exit /b

:startConsole

call :checkForUpdate

	if "%1"=="" (
		echo.
		echo( VasaltScript
		echo( ------------------------------------------------------------------------------
		echo( Please input a command
		echo( Usage: vasalt ^<command^>
		echo.
		exit /b
	)
	if "%1"=="--version" (
		echo.
		echo( VasaltScript
		echo( ------------------------------------------------------------------------------
		echo( You're currently using the !currentVasaltVersion! version of vasalt.
		echo( Local version: !currentVasaltVersion! ^| Server version: !serverVasaltVersion!
		echo.
		exit /b
	)

	if "%1"=="--update" (
		if !currentVasaltVersion! equ !serverVasaltVersion! goto quitAfterUpdate
		curl -L "https://raw.githubusercontent.com/IUrixl/VasaltScript/main/vasalt.bat" --output "Vasalt.bat" --progress-bar
		exit /b
	)

	if !currentVasaltVersion! neq !serverVasaltVersion! (
		echo.
		echo( VasaltScript
		echo( ------------------------------------------------------------------------------
		echo( You're currently using an outdated version, please update VasaltScript.
		echo( Local version: !currentVasaltVersion! ^| Server version: !serverVasaltVersion!
		echo( Usage: vasalt --update
		echo.
		exit /b
	) 

	if "%1"=="--run" (
		set dbg=false

		if "%2"=="" (
			echo.
			echo( VasaltScript
			echo( ------------------------------------------------------------------------------
			echo( Bad command usage, please input the filename to be executed.
			echo( Usage: vasalt --run ^<filename^>
			echo.
			exit /b
		)
		title VasaltScript ^| %2
		if not exist %2 goto breakFileMissing

		if not exist runtimeStack\ md runtimeStack
		echo ^<0x000f^> ^<0x000f^>>>runtimeStack\vars.tmp
		echo.
		
		rem MetaVars
		set argR=false
		set "_file_=%~1"
		@rem end

		call :kernel %2
		if !dbg!==false call :clearFolder runtimeStack
		exit /b
	)

	if "%1"=="--debug" (
		echo( VasaltScript
		echo( ------------------------------------------------------------------------------
		echo( Debuged
		echo( Usage: vasalt --debug
		
		if exist runtimeStack\ call :clearFolder runtimeStack
		exit /b
	)
	
	if "%1"=="--cmd" (
		goto :cmdInnit
	)

	if "%1"=="--help" (
		echo( VasaltScript
		echo( ------------------------------------------------------------------------------
		echo( Command list
		echo( --version ^| Display the current version
		echo( --update  ^| Download the lastest version from github
		echo( --run     ^| Run a file ^| args : ^<file^>
		echo( --cmd     ^| Start the vasalt cmdline from the windows cmd
		echo( --debug   ^| Clear runtime memory
		echo( --help    ^| Display the command list

		exit /b
	)

	:checkForUpdate
		curl -L "https://raw.githubusercontent.com/IUrixl/VasaltScript/main/PUBLICDATA" --output "currentVersion.vltVersion" --silent
		set /p serverVasaltVersion=<currentVersion.vltVersion
		set serverVasaltVersion=!serverVasaltVersion:~8!
		del currentVersion.vltVersion
		goto :eof


	:quitAfterUpdate
		echo.
		echo( VasaltScript
		echo( ------------------------------------------------------------------------------
		echo( Current version of Vasalt already updated. Use "vasalt --version" to see the actual version.
		echo( Local version: !currentVasaltVersion! ^| Server version: !serverVasaltVersion!
		echo( Usage: vasalt --version
		echo.
		exit /b

	:breakFileMissing
		echo.
		echo( VasaltScript
		echo( ------------------------------------------------------------------------------
		echo( Wrong arguments, file %2 not found
		echo( Usage: vasalt --run ^<filename^>
		echo.
		exit /b

call :clearFolder runtimeStack
endlocal
exit /b



:clearFolder <folder>
	goto _clearCore

	:_clearCore
		for /d %%A in (%~1\*) do (
			if exist %%A\* (
				call :clearFolder %~1\%%A\*
			) else (
				del /q %%A
			)
		)
		rd /q /s %~1

	goto :eof


REM Kernel
	:kernel <file>
	set varM=false
	set printM=false
	set osM=false
	set ifM=false
	set waitM=false
	set functionM=false
	set runFunM=false
	set argParser=false
	set importM=false
	set mathM=false
	set inputM=false
	set substringM=false
	set forM=false
	set ignoreM=false

	set concat=false

	goto compile

		:compile <file>
			for /f "tokens=* eol= " %%A in (%~1) do (
				set line=%%A
				set line=!line: =!
				set line=!line:        =!
				set rawLine=%%A

				if !ignoreM!==true goto :ignoreVoid

				REM Parse declaration
				if "!line:~0,1!"=="$" if !concat!==false set varM=true
				if "!line:~0,6!"=="print[" if !concat!==false set printM=true
				if "!line:~0,3!"=="os[" if !concat!==false set osM=true
				if "!line:~0,5!"=="wait[" if !concat!==false set waitM=true
				if "!line:~0,2!"=="if" if !concat!==false ( 
					set ifM=true
					set ifR=false
					set ifS=true
					set ifI=%RANDOM%
				)
				if "!line:~0,8!"=="function" if !concat!==false (
					set functionM=true
					set "funName=<0x000f>"
				)
				if "!line:~0,1!"==">" if !concat!==false set runFunM=true
				if "!line:~0,1!"=="{" if !concat!==false if !argR! neq false set argParser=true
				if "!line:~0,3!"=="-#-" if !concat!==false set _file_=!line:~3!
				if "!line:~0,3!"=="-?-" (
					if !dbg!==true (
						set dbg=false
					) else (
						set dbg=true
					)
				)
				if "!line:~0,6!"=="import" if !concat!==false set importM=true
				if "!line:~0,1!"=="=" if !concat!==false set mathM=true
				if "!line:~0,5!"=="input" if !concat!==false set inputM=true
				if "!line:~0,3!"=="for" if !concat!==false set forM=true
				if "!line:~0,4!"=="quit" if !concat!==false (
					set ignoreM=true 
					set CmdOn=false
				)
				if "!line!"=="vasaltVer" echo Current vasalt running version : !currentVasaltVersion!
				@rem if "!line:~0,9!"=="substring" if !concat!==false set substringM=true
				rem echo !varM! !printM! !osM!

				REM Innit modules
				if "!varM!"=="true" call :variable
				if "!printM!"=="true" call :print 
				if "!osM!"=="true" call :os
				if "!waitM!"=="true" call :wait
				if "!ifM!"=="true" call :ifService
				if "!functionM!"=="true" call :function
				if "!runFunM!"=="true" call :runFun
				if "!argParser!"=="true" if !argR!==fun call :funArgParser
				if "!importM!"=="true" call :importS
				if "!mathM!"=="true" call :mathS
				if "!inputM!"=="true" call :inputS
				if "!forM!"=="true" call :forS
				@rem if "!substringM!"=="true" call :substringS
			)

			goto :eof

		goto :eof
		echo breakpointed

		:forS
		if !concat!==true goto writeForSlot
		set "localForParams="
		set "localForMode="
		set "localForTag="
		set "localForIndex=1"

		for %%B in (!rawLine!) do (
			set "localForLine=%%B"
			if !localForIndex!==2 set localForParams=!localForLine!
			if !localForIndex!==3 set localForMode=!localForLine!
			if !localForIndex!==4 set localForTag=!localForLine:~1!
			set/a localForIndex=!localForIndex!+1
		)

		if exist runtimeStack\!localForTag!.form del runtimeStack\!localForTag!.form
		set concat=true

		goto :eof
			:writeForSlot
			if "!line!"=="!localForTag!]" (
				set concat=false
				goto runForSlot
			) else (
				echo !rawLine!>>runtimeStack\!localForTag!.form
			)
			goto :eof

			:runForSlot
				@rem Get params
				set localForVV=!localForParams:*^|=!
				for /f "tokens=1 delims=^|" %%B in ("!localForParams!") do ( set localForIV=%%B )

				if "!localForMode:~0,1!"=="$" (
					@rem Get params
					call :getVar !localForMode:~1!
					set localForStr=!returnedVar!
					set "returnedVar=<0x000f>"

					set localForLoopIndex=1
					for %%P in (!localForStr!) do (
						call :osWVar !localForIV! !localForLoopIndex!
						call :osWVar !localForVV! %%P
						call :kernel runtimeStack\!localForTag!.form

						set/a localForLoopIndex=!localForLoopIndex!+1
					) 
				)

				if "!localForMode:~0,2!"=="r[" (
					@rem Get params
					set localForMP=!localForMode:~2,-1!
					set localForME=!localForMP:*^|=!
					for /f "tokens=1 delims=^|" %%B in ("!localForMP!") do ( set localForMS=%%B )

					@rem Check if they're variables
					if "!localForMS:~0,1!"=="$" (
						call :getVar !localForMS:~1!
						set localForMS=!returnedVar!
						set "returnedVar=<0x000f>"
					)

					if "!localForME:~0,1!"=="$" (
						call :getVar !localForME:~1!
						set localForME=!returnedVar!
						set "returnedVar=<0x000f>"
					)

					set localForLoopIndex=!localForMS!
					for /l %%P in (!localForMS!,1,!localForME!) do (
						call :osWVar !localForIV! !localForLoopIndex!
						call :kernel runtimeStack\!localForTag!.form
						
						set/a localForLoopIndex=!localForLoopIndex!+1
					)
				)

				set forM=false
			goto :eof

		:substringS
			set "localSSIndex=1"
			set "localSSVar="
			set "localSSParams="
			set "localSSResult="
			set "localSSContent="

			for %%B in (!rawLine!) do (
				set "localSSLine=%%B"
				if !localSSIndex!==1 set localSSVar=!localSSLine:~10,-1!
				if !localSSIndex! gtr 1 if "!localSSParams!" neq "" set localSSParams=!localSSParams!,!localSSLine!
				if !localSSIndex! gtr 1 if "!localSSParams!" equ "" set localSSParams=!localSSLine!

				set/a localSSIndex=!localSSIndex!+1
			)

			call :getVar !localSSVar:~1!
			set localSSContent=!returnedVar!
			set localSSContent=!localSSContent!
			set p=!localSSContent!
			echo %p%

			echo !test!
			set "returnedVar=<0x000f>"

			call :osWVar !localSSVar! !localSSContent!

			set substringM=false
		goto :eof

		:inputS
			set "localInputVar="
			set "localInputPrompt="
			set "localInputIndex=1"

			for %%B in (!rawLine!) do (
				set "localInputLine=%%B"
				if !localInputIndex!==1 (
					set localInputVar=!localInputLine:~6!
					set localInputVar=!localInputVar:~0,-1!
				)
				if !localInputIndex! gtr 1 if "!localInputLine:~0,1!" neq "$" if "!localInputLine:~0,1!" neq "\" set localInputPrompt=!localInputPrompt! !localInputLine!
				if !localInputIndex! gtr 1 if "!localInputLine:~0,1!"=="\" set localInputPrompt=!localInputPrompt! 
				if !localInputIndex! gtr 1 if "!localInputLine:~0,1!"=="$" (
					call :getVar !localInputLine:~1!
					set localInputPrompt=!localInputPrompt! !returnedVar!
					set "returnedVar=<0x000f>"
				)
				set/a localInputIndex=!localInputIndex!+1
			)

			set/p localInputP=!localInputPrompt!
			call :osWVar !localInputVar! !localInputP!

			set inputM=false
		goto :eof

		:mathS
			set "localMathResult="
			set "localMathOp="
			set "localMathReturn="
			set "localMathIndex=1"

			for %%B in (!rawLine!) do (
				set localMathLine=%%B

				if !localMathIndex!==1 (
					set localMathLine=!localMathLine:~1!
					set localMathLine=!localMathLine:~0,-1!
					set localMathResult=!localMathLine!
				)
				if !localMathIndex! gtr 1 if "!localMathLine:~0,1!" neq "$" set localMathOp=!localMathOp! %%B
				if !localMathIndex! gtr 1 if "!localMathLine:~0,1!"=="$" (
					call :getVar !localMathLine:~1!
					set localMathOp=!localMathOp! !returnedVar!
					set "returnedVar=<0x000f>"
				)

				set/a localMathIndex=!localMathIndex!+1
			)

			set/a localMathReturn=!localMathOp!
			call :osWVar !localMathResult! !localMathReturn!

			set mathM=false
		goto :eof

		:importS
			set "localImportIndex=1"
			set "localImportAs=false"
			set "localImportName="
			set "localImportFile="

			for %%B in (!rawLine!) do (
				if !localImportIndex!==2 set localImportFile=%%B
				if !localImportIndex!==3 set localImportAs=true
				if !localImportIndex!==4 set localImportName=%%B

				set/a localImportIndex=!localImportIndex!+1
			)

			if !localImportAs!==true (
				set "localImportLastFile=!_file_!"
				set _file_=!localImportName!
				call :kernel !localImportFile!.vlt
				set _file_=!localImportLastFile!
			) else (
				call :kernel !localImportFile!.vlt
			)

			set importM=false

		goto :eof

		:funArgParser
			set "localArgArgI=1"

			for %%B in (!rawLine!) do (
				set "localArgArgC=%%B"
				if !localArgArgI!==1 set localArgRunIndex=!localArgArgC:~1,-1!
				if !localArgArgI!==2 set localArgRunName=!localArgArgC!

				set/a localArgArgI=!localArgArgI!+1
			)

			set localArgRI=1

			set "localArgFunName=!_file_!"

			for /f "tokens=* eol= " %%B in (runtimeStack\!localArgFunName!-runStack.funcStack) do (
				for %%C in (%%B) do (	
					set "localArgContent=%%C"

					if "!localArgContent!" neq "" if "!localArgContent:~0,1!"=="$" (
						call :getRawVar !localArgContent:~1!
						set localArgContent=!returnedVar!
						set "returnedVar=<0x000f>"
					)

					if !localArgRI!==!localArgRunIndex! (
						if "!localArgContent!"=="" (
							call :osWVar !localArgRunName! ^<0x000f^>
						) else (
							call :osWVar !localArgRunName! !localArgContent!
						)
					)
					set/a localArgRI=!localArgRI!+1
				)
			)

			set argParser=false
		goto :eof

		:runFun
			set localRunFunIndex=0
			set "localRunFunName=<0x000f>"
			set "localRunFunSynt="

			for %%B in (!rawLine!) do (
				set "localRunFunLine=%%B"
				if !localRunFunIndex!==0 set localRunFunName=!localRunFunLine:~1!
				if !localRunFunIndex! geq 1 set argR=fun

				if "!localRunFunSynt!" neq "" if !localRunFunIndex! geq 1 set localRunFunSynt=!localRunFunSynt! %%B
				if "!localRunFunSynt!"=="" if !localRunFunIndex! geq 1 set localRunFunSynt=%%B

				set/a localRunFunIndex=!localRunFunIndex!+1
			)
			echo !localRunFunSynt!>runtimeStack\!localRunFunName!-runStack.funcStack
			call :kernel runtimeStack\!localRunFunName!.tmp
			set argR=false
			set runFunM=false

		goto :eof

		:function
			if !concat!==true goto writeFunDataSlot

			set localReadIndex=0
			for %%B in (!rawLine!) do (
				set "localFunDec=%%B"

				if !localReadIndex!==1 set funName=!localFunDec!

				set/a localReadIndex=!localReadIndex!+1
			)

			if "!funName:~0,4!"=="-#-." (
				set funName=!funName:~4!
				set funName=!_file_!.!funName!
			)

			echo -#-!funName!>>runtimeStack\!funName!.tmp
			set concat=true
		goto :eof

			:writeFunDataSlot
				if "!rawLine!"==">]" (
					set concat=false
					set functionM=false
				) else (
					echo !rawLine!>>runtimeStack\!funName!.tmp
				)

			goto :eof

		:ifService
			if !concat!==true goto writeIfDataSlot
			if !ifR!==true goto runIfSlot 
			set "localIfFirstArg="
			set "localIfParser="
			set "localIfSecondArg="

			set "localIfIndex=1"
			set "localIfResult=false"

			set "localIfTag="

			REM Read first declaration
			for %%B in (!rawLine!) do (
				set localIfParsingValue=%%B

				if !localIfIndex!==2 (
					call :ifArgCheckVar !localIfParsingValue! localIfFirstArg
				)
				if !localIfIndex!==3 (
					set localIfParser=!localIfParsingValue!
				)
				if !localIfIndex!==4 (
					call :ifArgCheckVar !localIfParsingValue! localIfSecondArg
				)
				if !localIfIndex!==5 (
					set localIfTag=!localIfParsingValue:~-1!
				)

				set/a localIfIndex=!localIfIndex!+1
			)

			rem echo par !localIfParser!
			rem echo 1v !localIfFirstArg!
			rem echo 2v !localIfSecondArg!

			if "!localIfFirstArg!" neq "" if "!localIfParser!" neq "" if "!localIfSecondArg!" neq "" (
				if !localIfFirstArg! equ !localIfSecondArg! (
					if !localIfParser!==equ set localIfResult=true
				)
				if !localIfFirstArg! neq !localIfSecondArg! (
					if !localIfParser!==neq set localIfResult=true
				)
				if !localIfFirstArg! leq !localIfSecondArg! (
					if !localIfParser!==leq set localIfResult=true
				)
				if !localIfFirstArg! geq !localIfSecondArg! (
					if !localIfParser!==geq set localIfResult=true
				)
				if !localIfFirstArg! gtr !localIfSecondArg! (
					if !localIfParser!==gtr set localIfResult=true
				)
				if !localIfFirstArg! lss !localIfSecondArg! (
					if !localIfParser!==lss set localIfResult=true
				)
			) else (
				if "!localIfFirstArg!" neq "" if "!localIfParser!" equ "[" (
					if "!localIfFirstArg!"=="true" set localIfResult=true
				)
			)

			set concat=true

			goto :eof

				:writeIfDataSlot
					if "!line!"=="#else" set ifS=false
					if "!line!"=="!localIfTag!]" (
						set ifR=true
						set concat=false
						goto runIfSlot
					) else (
						if !ifS!==true (
							echo !rawLine!>>runtimeStack\!ifI!-true.tmp
						) else (
							if "!rawLine!" neq "else" echo !rawLine!>>runtimeStack\!ifI!-false.tmp
						)
					)
				goto :eof

				:runIfSlot
					if !localIfResult!==true (
						call :kernel runtimeStack\!ifI!-true.tmp
					) else (
						if exist runtimeStack\!ifI!-false.tmp call :kernel runtimeStack\!ifI!-false.tmp
					)
					set ifM=false
				goto :eof


				:ifArgCheckVar <string> <arg>
					set "localIfCheckVarValue=%~1"
					if "!localIfCheckVarValue:~0,1!"=="$" (
						call :getVar !localIfCheckVarValue:~1!
						set %~2=!returnedVar!
						set "returnedVar=<0x000f>"
					) else (
						set %~2=!localIfCheckVarValue!
					)

				goto :eof

		:wait
			set localWaitTime=!rawLine:~5,-1!
			if "!localWaitTime:~0,1!"=="$" (
				call :getVar !localWaitTime:~1!
				set localWaitTime=!returnedVar!
				set "returnedVar=<0x000f>"
			)

			rem Start timeout
			timeout /t !localWaitTime! /nobreak>nul
			set waitM=false
		goto :eof

		:os 
			set localOsType=normal
			if !concat!==true (
				if "!rawLine!"=="]" (
					set osM=false
					set concat=false
					set localOsType=normal
					call :runOsFile
					rem del runtimeStack\currentOsConcat.tmp
				) else (
					echo !rawLine!>>runtimeStack\currentOsConcat.tmp
				)
			)

			rem check if is a concat
			if "!rawLine:~3,6!"=="concat" set localOsType=concat & set concat=true

			rem check if normal
			if "!localOsType!"=="normal" if !concat!==false (
				set localRuntimeOsCmd=!rawLine:~3,-1!
				!localRuntimeOsCmd!
				set osM=false
			)

			goto :eof

				:runOsFile
					for /f "tokens=* eol= " %%B in (runtimeStack\currentOsConcat.tmp) do (
						set "localCmdRunningOnConcatenation=%%B"
						!localCmdRunningOnConcatenation!
					)

					goto :eof

		:print
			set "localPrintString="
			
			set rawLine=!rawLine:~6!
			set rawLine=!rawLine:~0,-1!
			
			for %%B in (!rawLine!) do (
				set localPrintParsingValue=%%B
				if "!localPrintParsingValue:~0,1!"=="$" (
					call :getVar !localPrintParsingValue:~1!
					set localPrintString=!localPrintString! !returnedVar!
					set "returnedVar=<0x000f>"
				) else (
					set localPrintString=!localPrintString! !localPrintParsingValue!
				)
			)

			rem Print result
			if "!localPrintString:~1!"=="" (
				echo Input values to be printed
			) else (
				echo !localPrintString:~1!
			)

			set printM=false
			goto :eof

		:getVar <name>
			set "returnedVar=<0x000f>"
			set "localReadIndex=1"
			set "localGotReadValue=false"

			for /f "tokens=* eol= " %%B in (runtimeStack\vars.tmp) do (
				set localReadIndex=1
				set localGotReadValue=false
				for %%C in (%%B) do (
						set cReadLine=%%C

						if !localReadIndex!==1 (
							if "!cReadLine!"=="%~1" set localGotReadValue=true
						) else (
							if "!localGotReadValue!"=="true" (
								if "!returnedVar!"=="<0x000f>" (
									set returnedVar=!cReadLine:"=!
									set localGotReadValue=true
								) else (
									set returnedVar=!returnedVar! !cReadLine:"=!
									set localGotReadValue=false
								)
							)
						)
						set/a localReadIndex=!localReadIndex!+1
					)
				)
			)
			
			goto :eof

			:getRawVar <name>
				set "returnedVar=<0x000f>"
				set "localReadIndex=1"
				set "localGotReadValue=false"

				for /f "tokens=* eol= " %%B in (runtimeStack\vars.tmp) do (
					set localReadIndex=1
					set localGotReadValue=false
					for %%C in (%%B) do (
							set cReadLine=%%C

							if !localReadIndex!==1 (
								if "!cReadLine!"=="%~1" set localGotReadValue=true
							) else (
								if "!localGotReadValue!"=="true" (
									if "!returnedVar!"=="<0x000f>" (
										set returnedVar=!cReadLine!
										set localGotReadValue=true
									) else (
										set returnedVar=!returnedVar! !cReadLine!
										set localGotReadValue=false
									)
								)
							)
							set/a localReadIndex=!localReadIndex!+1
						)
					)
				)
			
			goto :eof

		:variable
			set varIndex=1
			set "varName=<0x000f>"
			set "varContent=<0x000f>"

			for %%B in (!rawLine!) do (
				set currentRaw=%%B

				REM Get name
				if !varIndex!==1 set varName=!currentRaw:~1!
				REM Get content
				if !varIndex!==2 set varContent=!currentRaw!


				REM Add index
				set/a varIndex=!varIndex!+1
			)

			REM Rewrite var slots
			set "localRewriteIndex=1"
			set "localRewritten=false"
			set "localRewRaw=elpepe"
			set "ignoreThisLine=false"
			set "localRewLI=0"
			for /f "tokens=* eol=" %%B in (runtimeStack\vars.tmp) do (
				set localRewriteIndex=1

				if !ignoreThisLine!==false if !localRewLI! gtr 0 (
					echo !localRewRaw!>>runtimeStack\varsR.tmp
				)

				set "localRewRaw="
				set ignoreThisLine=false

				set/a localRewLI=!localRewLI!+1

				for %%C in (%%B) do (
					set "localReadRewLin=%%C"

					if !localRewriteIndex!==1 if !localReadRewLin!==!varName! (
						set localRewritten=true
						set ignoreThisLine=true
						echo !varName! !varContent!>>runtimeStack\varsR.tmp
					)
					if !localReadRewLin! neq !varName! if !ignoreThisLine!==false (
						if !localRewriteIndex!==1 (
							set localRewRaw=!localReadRewLin!
						) else (
							set localRewRaw=!localRewRaw! !localReadRewLin!
						)
					)

					set/a localRewriteIndex=!localRewriteIndex!+1
				)
			)

			if !localRewritten!==false (
				echo !varName! !varContent!>>runtimeStack\vars.tmp
				if exist runtimeStack\varsR.tmp del runtimeStack\varsR.tmp
			) else (
				del runtimeStack\vars.tmp
				ren runtimeStack\varsR.tmp vars.tmp
			)

			set varM=false

			goto :eof


			:osWVar
				set varName=%~1
				set varContent=%~2

				REM Rewrite var slots
				set "localRewriteIndex=1"
				set "localRewritten=false"
				set "localRewRaw=elpepe"
				set "ignoreThisLine=false"
				set "localRewLI=0"
				for /f "tokens=* eol=" %%B in (runtimeStack\vars.tmp) do (
					set localRewriteIndex=1

					if !ignoreThisLine!==false if !localRewLI! gtr 0 (
						echo !localRewRaw!>>runtimeStack\varsR.tmp
					)

					set "localRewRaw="
					set ignoreThisLine=false

					set/a localRewLI=!localRewLI!+1

					for %%C in (%%B) do (
						set "localReadRewLin=%%C"

						if !localRewriteIndex!==1 if !localReadRewLin!==!varName! (
							set localRewritten=true
							set ignoreThisLine=true
							echo !varName! !varContent!>>runtimeStack\varsR.tmp
						)
						if !localReadRewLin! neq !varName! if !ignoreThisLine!==false (
							if !localRewriteIndex!==1 (
								set localRewRaw=!localReadRewLin!
							) else (
								set localRewRaw=!localRewRaw! !localReadRewLin!
							)
						)

						set/a localRewriteIndex=!localRewriteIndex!+1
					)
				)

				if !localRewritten!==false (
					echo !varName! !varContent!>>runtimeStack\vars.tmp
					if exist runtimeStack\varsR.tmp del runtimeStack\varsR.tmp
				) else (
					del runtimeStack\vars.tmp
					ren runtimeStack\varsR.tmp vars.tmp
				)

				set varM=false

			goto :eof



	goto :eof

endlocal

:ignoreVoid
