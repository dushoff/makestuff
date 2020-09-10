A listdir is designed to control a bunch of directories, and build a screen_session and handle their version control (with all.time and related tools from makestuff/git.mk).

A listdir is weirdly controlled by a pair of files: screens.list and screens.arc, which are _made frome each other_. This is sort of an anachronism. Before I learned about <screenkey>-", I would micromanage the numbering of screens is screens.list and get git conflicts.

screens.list does all of the work, and is also the one to edit and to work from. screens.arc is under version control and is made automatically from screens.list when the directory is synced. screens.list is evaluated and often remade from screens.arc when the listdir screen_session: is launched via the rule screens.update:
