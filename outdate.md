

If I run a script, it's important that its target not be up-to-date after a failed run.

But the script might produce output that I would like to see after a failed run.

There are two ways that I do this.

Intermediate output
1. Delete the target
2. Run the script and put the output into a temporary or hidden file
3. If (success) move the intermediate file to the target

Outdating
1. Run the script normally
2. If (!success) do something to outdate the target
2b. Best might be to make all of my special recipes depend on a special, hidden checkfile

What are the issues? Try with python

Working right now in python.mk using the idea of checkfiles
