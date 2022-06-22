A listdir is designed to control a bunch of directories, and build a screen_session and handle their version control (with all.time and related tools from makestuff/git.mk).

A listdir is weirdly controlled by a pair of files: screens.list and screens.arc, which are _made from each other_. This is sort of an anachronism. Before I learned about <screenkey>-", I would micromanage the numbering of screens in screens.list and get git conflicts. So the complexity probably isn't needed after all, but rarely causes much trouble.

screens.list (see makestuff/screenlist.md) does all of the work, and is also the one to edit and to work from. screens.arc is under version control and is made automatically from screens.list when the directory is synced. screens.list is evaluated and often remade from (via the rule screens.update) when the listdir screen_session is launched.

screens.list shapes the screen_session using .mk files made by perl scripts. Presumably.

screens_resource: tries to fill in resources for directories in screens.list. If the directory exists and is a repo, it will add the repo url in some appropriate way to the file. It's also meant to do something about copy locations, but it doesn't look like the relevant script is doing that.

To set up listdir foo:
* find or create a repo (any name)
* add it (as foo:) to screens.list in the topdir
* open it as ssx
* build a Makefile from makestuff/screendir.Makefile
* make a screens.list in the directory
* make
	* screen_session, OR
	* foo.subscreen from the parent (if inactive)
