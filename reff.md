# reff: reference lists from PubMed identifiers

`reff.mk` builds bibliographies, browsable reading lists and a local PDF library from one hand-edited list of article identifiers. Records come from PubMed (via Biopython's Entrez), so everything has to resolve to a PMID.

## Setup

In the project Makefile:

```make
-include makestuff/reff.mk
```

You also need:
* perl rules (`PUSH`, `PUSHRO`) and python rules (`PITH`, `*.pip`) from the usual makestuff includes
* a `library/` directory if you want PDFs (see [PDF library](#pdf-library))

`make` links `makestuff/reff` into the project as `reff/` (ignored) and creates `bibdir/` the first time they're needed.

## The one file you edit: `name.rmu`

An `.rmu` file lists one publication per directive line:

```
Mossong Polymod
PMID: 18366252

PMCID: PMC1234567
DOI: 10.1371/journal.pmed.0050074
```

* A directive is `PMID:`, `PMCID:` or `DOI:` followed by the identifier. Leading whitespace, `*` and `#` are allowed, so a directive inside a Markdown bullet or heading still counts.
  * This means `## PMID: …` does **not** comment a directive out. To drop an entry, delete it or break the keyword (e.g., `xPMID:`).
* Every other line is ignored, so you can annotate freely.
* PMCIDs and DOIs are resolved to PMIDs by a PubMed search. Papers that aren't in PubMed can't be used.
* If two directives resolve to the same PMID, a `DUPLICATE PMID` warning goes to stderr. The record still appears twice in the output.

## Pipeline

```
name.rmu ──► name.recs ──► name.reff.pgr ──► name.tags.pgr ─┬─► name.reff.bib
   (rmu.py)       (recspgr.pl)       (tags.pl)         ├─► name.reff.MD ─┐
                                                       └─► name.downloads ┴─► name.gfm ──► name.reff.html
                                                            (download.py)     (MDgfm.pl)     (pandoc)
```

| File | What it is |
|---|---|
| `.recs` | Raw MEDLINE records for every entry in the `.rmu` |
| `.reff.pgr` | One paragraph per paper in a simple `KEY: value` format (AU, TI, SO, PUB, VI, PG, PMID, PMC, DOI, AB) |
| `.tags.pgr` | The same, with a `TAG:` line added. **This is the main target**; everything else is built from it |
| `.reff.bib` | BibTeX (`@article` entries keyed by TAG) |
| `.reff.MD` | Plain-text reading list with links and abstracts |
| `.downloads` | Log of an attempt to fetch PDFs into `library/` |
| `.gfm`, `.reff.html` | Browsable reading list, with links to local PDFs that exist |

Everything except `.rmu` and `bibdir/*.corr` is generated and ignored.

Typical targets:
* `make name.reff.bib` to cite from LaTeX
* `make name.reff.html` to browse, which also triggers `name.downloads` (see below)

## Record cache: `bibdir/`

`rmu.py` caches each MEDLINE record as `bibdir/PM<pmid>.rec`. For each entry it uses, in order:
1. `bibdir/PM<pmid>.corr` if it exists
2. otherwise `bibdir/PM<pmid>.rec`
3. otherwise it fetches the record from PubMed (in one batch with the other missing records) and saves it as `.rec`

`.rec` files are ignored and can be regenerated. To delete a cached record, remove the `.rec` file; it's refetched on the next build.

### Corrections

To fix a bad record (wrong author spelling, title, journal abbreviation, etc.):

```
cp bibdir/PM12345.rec bibdir/PM12345.corr
# edit the .corr
```

`.corr` files are tracked in `Sources`, and any `.recs` file is remade when any `.corr` file changes. Fix the record here, not in a downstream file, because downstream files are overwritten.

## Tags

`tags.pl` makes each citation key from:

> first author's surname + year + first title word of 4 or more letters

It lowercases the key and strips non-word characters, e.g. `mossong2008social`. A clash produces a `REPEATED tag` warning, but nothing fails. Tags name the PDFs in `library/` too, so a correction that changes the first author, year or title also changes the tag. Then the PDF has to be renamed.

## PDF library

PDFs live in `library/<TAG>.pdf`. An optional supplement goes in `library/<TAG>Supp.pdf`. You manage `library/` yourself (local directory, rclone, git, or a symlink to a shared location), and `reff.mk` doesn't create it.

`name.downloads` runs `download.py` over `name.tags.pgr`. For each paper whose PDF isn't already there it tries, in order:
1. PMC (`/articles/<PMC>/pdf/`)
2. Unpaywall (by DOI)
3. a direct DOI link, accepted only if it returns a real PDF

The `.downloads` file logs which source worked and lists the URLs that failed. Many publishers block automated downloads, so expect to fetch some PDFs by hand: open `name.reff.html` (or `name.gfm`), follow the PubMed/PMC/doi links, and save the file as `library/<TAG>.pdf`.

`name.gfm` depends on `name.downloads`, so building the HTML tries downloads first. To retry after adding PDFs or changing access, remove `name.downloads` and rebuild.

## Caveats

* medRxiv records are skipped (with a warning) when making `.reff.pgr`.
* An identifier that can't be resolved prints `ERROR: could not resolve PMID …` into `.recs`, not to stderr. Check for that line in `.recs`.
* Within `.recs`, records come in the order cached first, then newly fetched, not in `.rmu` order.
* `.reff.bib` only writes `@article`, with title, author, journal, volume, pages and year.
* Some scripts for looking up DOIs exist, but they're not part of this pipeline.
