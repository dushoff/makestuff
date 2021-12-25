
maketouch = cd $(1) && $$(MAKE) $$* && touch $$*

## This could loop forever (if you have two targets in the same directory)
## Maybe improved? 2020 Oct 20 (Tue)
define hotmake
$(1)/Makefile: 
	$(MAKE) $1
$(1)/%: $(1) $(1)/Makefile 
	$(maketouch)
endef

## Why does this loop? Shouldn't the more explicit rule cancel the % rule
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
