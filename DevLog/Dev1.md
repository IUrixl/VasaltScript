# DevLog 1 
Improved variable's method.

## Issue
"Memory Leak" issue.
So lets understand how variables works in Vasalt. Normal variables are stored in a single section, they were stored by name and then by their value. 

The issue was that it only writted new values, it didnt removed the old ones. So the section ended looking like this:
```
myVar 123
myVar 1233
myVar 12345
myVar 1236
myVar 1233
```
This was a mess for future updates, so i decided to rework it. It mean to update every single method that had variable support in vasalt.

## Solution
I make a code that would search the variable position on the section and then overwrite the whole line to update his value. So if you changed the value it will change the value too but without writting again the same variable in a new position.

It can make vasalt a little bit more slow ( not much ), but thanks to it i will be able to add a lot of new things to vasalt.

### Visual example
#### Vasalt script
```vlt
$myVar 123
$secondVar 321
```
#### Memory
```
myVar 123
secondVar 321
```
#### Vasalt script
```vlt
$myVar 123
$secondVar 321

$myVar 124
```
#### Memory
```
myVar 124
secondVar 321
```
