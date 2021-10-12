Ignore += word media
%.media: %.docx
	unzip -o $< word/media/*
	mv word/media $@

%.mediadir: %.media
	$(RM) media
	ln -fs $< media

