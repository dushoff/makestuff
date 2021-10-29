Ignore += word media
%.media: %.docx
	unzip -o $< word/media/*
	$(RMR) $@
	mv word/media/ $@

## This will remake forever, which seems OK since media is a temporary place.
## Better solution would be to change the pointers to <foo>.media in the pipeline
%.mediadir: %.media
	$(RM) media
	ln -fs $< media

