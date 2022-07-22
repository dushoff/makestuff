
maketouch = cd $(1) && $$(MAKE) $$* && touch $$*

## This could loop forever (if you have two targets in the same directory)
## Maybe improved? 2020 Oct 20 (Tue)
define hotmake
$(1)/Makefile: | $1
$(1)/%: $(1)
	$(maketouch)
endef

## Why does this loop? Shouldn't the more explicit rule cancel the % rule
define coldmake
$(1)/%.mk: ;
$(1)/Makefile: ;
$(1)/%: | $(1)/Makefile 
	$(maketouch)
endef

## Adding to call from elsewhere
$(foreach dir,$(hotdirs),$(eval $(call hotmake,$(dir))))
$(foreach dir,$(colddirs),$(eval $(call coldmake,$(dir))))
