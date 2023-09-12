# VasaltScript
Vasalt is a "programming language" made to see how far i can go using only batch.
It's not intended to be a professional language so don't expect big things (building into .exe is not avaliable).

![Batch](https://img.shields.io/badge/Batch-%23000000.svg?style=for-the-badge&logo=GNUBash&logoColor=white)
![Version](https://img.shields.io/badge/Version-1.01b-9cf?style=for-the-badge)

## Download
You only need to download **vasalt.bat**, the other things can be deleted from your download :).

## Index
- [Basic guide](#basic-guide)
    - [Create a file](#creation-of-files)
    - [Execute a file](#executing-a-file)
    - [Check the version](#check-current-version)
    - [Updating Vasalt](#updating-vasalt)
    - [Custom cmdline](#vasalt-cmdline)
    - [Display help](#vasalt-help)
 - [Syntaxis basics](#syntaxis-basics)
    - [Command syntaxis](#commands-syntaxis)
    - [Command concatenation](#command-concatenation)
    - [Crash characters](#crash-characters)
    - [Variables](#variables)
        - [Normal](#normal-variables)
        - [StringBasedVar](#stringbasedvars)
    - [Print](#print)
    - [Os](#os)
        - [Normal](#normal-os)
        - [Concat](#concat-os)
    - [Wait](#wait)
        - [Normal](#normal-wait)
        - [Variable](#variable-wait)
    - [If](#if)
        - [Boolean if](#boolean-if)
        - [Params if](#params-if)
    - [Function](#functions)
    - [Import](#import)
        - [Normal](#normal-import)
        - [As import](#as-import)
    - [Math](#maths)
        - [Normal](#normal-maths)
        - [Variable](#variable-maths)
     - [Quit](#quit)
- [Libraries](#libraries)
    - [Types](#types-of-libraries)
    - [Create](#creating-libraries)

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
### Vasalt cmdline
If you doubleclick vasalt you will open the cmdline of vasalt, meanwhile opening it from cmd while use the compiler mode.

Other method to run the cmdline is calling it by the cmd.
```cmd
    vasalt --cmd
```
### Vasalt help
```cmd
    vasalt --help
```

## Syntaxis basics
### Commands syntaxis
Here at Vasalt, to use a command you must use "[]" instead of "()" like in other languages.
### Command concatenation
Another function of Vasalt is concatenation, so in a specified list of command you can concate arguments.
### Crash characters
The following characters may crash your script (depending on witch batch version are you using)
```
  ?
```

Exceptions:
Os concatenation allow spaces at the beggining and tabulations.
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
#### Normal Os
```vlt
  os[echo 1]
  os[cls]
  os[exit]
```
#### Concat Os
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
#### Normal Wait
Basic script example
```vlt
print[Waiting 1 second]
wait[1]
print[Time waited succesfully]
```
#### Variable Wait
Basic script example
```vlt
$secs = 4
print[Waiting $secs]
wait[$secs]
print[Succesfully waited $secs]
```
### If
Tag can be changed to any text, it only works to identify the if to be closed and defined.
#### Boolean If
```vlt
 $boolean true
 
 if $boolean [tag
    print[it's true]
 #else
    print[it's false]
 tag]
```
#### Params if
Params :
```vlt
 equ = equal
 neq = not equal
 gtr = greater
 lss = less
 leq = less or equal
 geq = greater or equal
```

```vlt
$myVar 1

if $myVar neq 0 [tag
    print[it's not 0]
#else
    print[it's 0]
tag]
```

### Functions
Basic function example
```vlt
function myFunc [
    print[Hello world]
>]

>myFunc
```

Passing args
```vlt
function myFunc [
    {1} argInPos1
    print[$argInPos1]
>]

>myFunc "Hello world
print[My arg was $argInPos1]
```

Variable as argument
```vlt
$var "Hello world"

function myFunc [
    {1} arg
    print[$arg]
>]

>myFunc $var
print[The var i sent was $var & the argument i recieved was $arg]
```

### Import
#### Normal import
Don't add the .vlt at the end.
```vlt
import file
```
#### As import
```vlt
import file as f
```

### Maths
#### Normal math
Spaces are not important here.
```vlt
=[returnVar] 1+1
=[rV] 1 + 1

print[$returnVar & $rv]
```
#### Variable maths
Spaces are very important here.
```vlt
$num1 1
$num2 5

=[rV] $num1 + $num2

print[rV]
```

### Input
```vlt
$textSample "works with vars too"
input[returnVar] Did you knew that inputs $textSample

print[$returnVar]
```
#### Input space at the end
```vlt
input[rV] Input your age : \

print[$rV]
```

### Quit
Makes the code quit running.
```vlt
    quit
```

### For
#### Range for
```vlt
$start 1
$end 10
    
for yourVarIndex|yourContentVar r[$start|$end] [tag
    print[$yourVarIndex]
tag]
```
```vlt
for i|v r[1|20] [f
    print[$i]
f]
```
#### String for
```vlt
$myStr "Hello world this is my string"
    
for i|v $myStr [f
    print[Index : $i & Content $v]
f]
```

## Libraries
### Types of libraries]
#### Basic libraries
They don't require to use import as, using import will work with them.
#### Advanced libraries
They require to use import as.
### Importing
To import a library you must use [import as](#as-import)
```vlt
import myCoolLibrary as lib
```
### Creating libraries
#### Basic
Basic library's functions can only be executed by the name written on the declaration.
```vlt mylib.vlt
function mylib.main [
    {1} arg
    print[$arg]
]
```

```vlt main.vlt
import mylib

>mylib.main "hello world"
```
#### Advanced
Advancd library's function's name can be assigned by the users using the import as method.
```vlt mylib.vlt
function -#-.main [
    {1} arg
    print[$arg]
]

```

```vlt main.vlt
import mylib as lib

>lib.main "hello world"
```
