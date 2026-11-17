# makegraph.mk

Draw the dependency graph of a make target as a PDF, using [make2graph](https://github.com/lindenb/makefile2graph) and graphviz `dot`. Experimental.

Include it in your Makefile like other makestuff:

```make
-include makestuff/makegraph.mk
```

## Building a graph name

Start from a target, add a trace step, add any filters, and end with `.mg.pdf`:

| Piece | What it does |
|---|---|
| `foo.nd` | Trace `make -nd foo` in this directory (a dry run, so only out-of-date things show as needing to be made) |
| `foo.final.nd` | Same, but with `makeSlow` on, so the graph goes through saved slow targets to their sources (see slowtarget.md) |
| `foo.dd` | Trace `foo.nd` in a fresh clone (`foo.dd/`, from git.mk), so the graph shows a build from scratch. Only committed files are in the clone |
| `foo.final.dd` | Fresh clone, with `makeSlow` on |
| `.nom` | Filter: drop makestuff machinery (`makestuff/*`, `*.mk`, `Makefile`, stamps) |
| `.ns` | Filter: drop the `slow` and `slowtarget` directory nodes and merge each `slow/X` into `slowtarget/X` |
| `.mf` | Filter: `.nom` and `.ns` together, in one pass |
| `.mg.pdf` | Run make2graph on the trace and draw it |

Examples:

```
make targets.nd.nom.mg.pdf             ## Local, current state
make targets.final.dd.mf.mg.pdf        ## Whole project from scratch, through slow targets
```

Filters can go in either order. Use `.mg.dot` instead of `.mg.pdf` to get the dot file.

## Notes

* Filters edit the dot file using `mgFilter.pl`. Don't filter the trace with grep: make2graph reads the trace as nested blocks, and dropping lines gives broken graphs.
* `foo.final` itself doesn't graph well: it calls a recursive make, and make2graph can't follow that. Use `foo.final.nd` instead.
* Recipes that call `$(MAKE)` still run during `make -n`, so recursive makes will clutter the trace.
* For slow targets, declare dependencies on `slowtarget/X.Rout`, not `slow/X.Rout`, or the final graph stops at `slowtarget/X`.
