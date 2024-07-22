It would be good to make the final main target have the canonical name, doc.pdf: doc.tex

Help!! We want .tex.deps to signal when we have to remake the tex.pdf. But we also needed .makedeps for some reason …

It feels like there's no way to make the current paradigm work with inclusions. We don't know if a file has its dependencies up to date  unless we go into its personal .tex.mk to see what it depends on. So we can never treat its deps as up to date on a new make. So anything that depends on it can't be up to date either. 

The thing to do is to include all the make files (like webpix), or do some sort of thing where you include everything you happen to have (and make them as side-effects) -- OR, specify what generated files go in a specific tex.mk file. So let's try the last one.
