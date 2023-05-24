# VasaltScript
Vasalt is a "programming language" made to see how far i can go using only batch.
It's not intended to be a professional language so don't expect big things (building into .exe is not avaliable).

![Batch](https://img.shields.io/badge/Batch-%23000000.svg?style=for-the-badge&logo=GNUBash&logoColor=white)
![Version](https://img.shields.io/badge/Version-1.01b-9cf?style=for-the-badge)

## Basic guide
### Creation of files
To create a VasaltScript file, name your file to whatever you want and then add .vlt at the end.
### Executing a file
In order to execute your file, you must go to the cmd and then type:
```cmd
vasalt --run <file>.vlt
```
### Check current version
If you want to check what version of Vasalt are you using type in the cmd the following command.
```cmd
vasalt --version
```
### Updating vasalt
If your version is uptodate, you must update vasalt. To do that, go to the cmd andtype:
```cmd
vasalt --update
```

## Syntaxis basics
### Commands syntaxis
Here at Vasalt, to use a command you must use "[]" instead of "()" like in other languages.
### Command concatenation
Another function of Vasalt is concatenation, so in a specified list of command you can concate arguments.
### Variables
Variables cannot be concatenated at the moment, to store multiple values on the same line you must create a StringBasedVar.
### Crash characters
The following characters may crash your script (depending on with batch version are you using)
```
  ?, spaces at the beggining, tabulations
```
#### Normal variables
```vlt
  $myVar Value1
```
#### StringBasedVars
```vlt
  $myStringBasedVar "Value1 Value2"
```
### Print
Basic print scripts
```vlt
  print[Hello World]
```
```vlt
  $myStringBasedVar "Hello World"
  print[$myStringBasedVar]
```
```vlt
  $myStringBasedVar "How are you"
  print[Hello World $myStringBasedVar]
```
### Os
Using os commands you can execute batch commands in a vasalt script.
#### Normal
```vlt
  os[echo 1]
  os[cls]
  os[exit]
```
#### Concat
Concat a list of batch commands to be executed.
```vlt
  os[concat
    cls
    echo 1
    echo 2
    echo 3
    exit
  ]
```

### Wait
#### Normal
Basic script example
```vlt
print[Waiting 1 second]
wait[1]
print[Time waited succesfully]
```
#### Variable
Basic script example
```vlt
$secs = 4
print[Waiting $secs]
wait[$secs]
print[Succesfully waited $secs]
```
### If
#### Boolean If
```vlt
 $boolean true
 
 if $boolean [
 print[it's true]
 #else
 print[it's false]
 ]
```
