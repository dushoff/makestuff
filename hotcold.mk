
maketouch = cd $(1) && $$(MAKE) $$* && touch $$*

## This could loop forever (if you have two targets in the same directory)
define hotmake
$(1)/%: $(1) $(1)/Makefile 
	$(maketouch)
endef

## This is circular; what would happen if we used a wildcard scope before the percent rule?
define coldmake
$(1)/%.mk: ;
$(filter-out $(1)/Makefile, $(wildcard $(1)/*)): $(1)/%: $(1)/Makefile 
	$(maketouch)
endef

torq:

## Adding to call from elsewhere
$(foreach dir,$(hotdirs),$(eval $(call hotmake,$(dir))))
$(foreach dir,$(colddirs),$(eval $(call coldmake,$(dir))))
