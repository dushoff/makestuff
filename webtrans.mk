images: $(images)
thumbs: $(thumbs)

%.thumb.png: %.png
	convert -resize x200 $< $@

%.thumb.png: %.jpg
	convert -resize x200 $< $@

%.thumb.png: %.gif
	convert -resize x200 $< $@

## Really belongs in webpix, since it's not html-specific. Eliminate when legacies are gone
%.png: %.svg
	convert $< $@
