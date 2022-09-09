## Sed
-------

### General processing framework

* Sed applies the entire script to the first input line before reading the second input line and applying the editing script to it. Because sed is always working with the latest version of the original line, any edit that is made changes the line for subsequent commands. Sed doesn’t retain the original. This means that a pattern that might have matched the original input line may no longer match the line after an edit has been made.

* Some sed commands change the flow through the script. For example, the N command reads another line into the pattern space without removing the current line, so you can test for patterns across multiple lines.

### Addressing

-> To address we use the /pattern/ if we want to address a specific section of the input: /pattern1/,/pattern2/ (the line containing the second pattern is also included)

-> If we are using numeric addressing, it should not contain the '/' characters. Just two numbers separated by comma. ($ for the last line of input)

This two types of addressing can be combined.

• If no address is specified, then the command is applied to each line.
• If there is only one address, the command is applied to any line matching the address.
• If two comma-separated addresses are specified, the command is performed on the first line matching the first address and all succeeding lines up to and including a line matching the second address.
• If an address is followed by an exclamation mark ```!```, the command is applied to all lines that do 
not match the address.

Braces ({}) are used in sed to nest one address inside another or to apply multiple commands at the same address.

* An ```=``` sign after an address alows you to get the line number of the matched pattern.

### Substitution

* Pattern delimiter can be any given character. Most be escaped if it appears within the pattern.

-> Special character ```&``` is replaced by the matched pattern.
-> Numeric flags are used to specify the instance of the pattern in which you want to make the replacement. 

### Next line

-> The command ```N``` can be use to work on the next line of input. 
