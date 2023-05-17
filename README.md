# VasaltScript
Vasalt is a "programming language" made to see how far i can go using only batch.
It's not intended to be a professional language so don't expect big things (building into .exe is not avaliable),

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
#### Normal variables
```vlt
  $myVar Value1
```
#### StringBasedVars
```vlt
  $myStringBasedVar "Value1 Value2"
```
### Print
#### Normal print
Supported at print concatenation. Normal print won't remove " from the text.
```vlt
  print[Hello world]
```
#### Break print
A void space, not supported at print concatenation.
```vlt
  print[\]
```
#### Var print
Print variable balue, supported at print concatenation. Variable print will remove " from StrinBasedVars
```vlt
  print[$myVar]
``` 
#### Concatenation print
Print multiple values and text in the same line.
```vlt
  $myStr "How are you"
  
  print[concat
    Hello
    World
    $myStr
  ]
```
Output:
```
Hello World How are you
```
### Os
