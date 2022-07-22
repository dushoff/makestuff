
maketouch = cd $(1) && $$(MAKE) $$* && touch $$*

## Maybe improved? 2020 Oct 20 (Tue)
define hotmake
$(1)/Makefile: | $(1)
$(1)/%: $(1)
	$(maketouch)
endef

define coldmake
$(1)/%.mk: ;
$(1)/Makefile: | $(1)
$(1)/%: | $(1)/Makefile 
	$(maketouch)
endef

## Adding to call from elsewhere
$(foreach dir,$(hotdirs),$(eval $(call hotmake,$(dir))))
$(foreach dir,$(colddirs),$(eval $(call coldmake,$(dir))))
