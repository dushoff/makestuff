
maketouch = cd $(1) && $$(MAKE) $$* && touch $$*

## This could loop forever (if you have two targets in the same directory)
define hotmake
$(1)/%: $(1) $(1)/Makefile 
	$(maketouch)
endef

define coldmake
$(1)/%.mk: ;
$(1)/Makefile: ;
$(1)/%: $(1)/Makefile 
	$(maketouch)
endef

## Only expected to work for things that already exist!
## Because that's what wildcard does
## Could be deleted? 2020 Oct 15 (Thu)
define oldmake
$(1)/%.mk: ;
$(filter-out $(1)/Makefile, $(wildcard $(1)/*)): $(1)/%: $(1)/Makefile 
	$(maketouch)
endef

## Adding to call from elsewhere
$(foreach dir,$(hotdirs),$(eval $(call hotmake,$(dir))))
$(foreach dir,$(colddirs),$(eval $(call coldmake,$(dir))))
