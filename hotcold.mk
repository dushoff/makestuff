
## Still experimenting with these two; I guess they're the same
## catalyzing problem was elsewhere
## maketouch = cd $(1) && $$(MAKE) Makefile && $$(MAKE) $$* && touch $$*
maketouch = $$(MAKE) -C $(1) Makefile && $$(MAKE) -C $(1) $$* && touch $(1)/$$*

## Maybe improved? 2020 Oct 20 (Tue)
## Still will loop forever if you're calling two things from the same place
define hotmake
$(1)/%: $(1)
	$(maketouch)
endef

## Fiddling 2023 Mar 20 (Mon)
define coldmake
$(1)/%.mk: ;
$(1)/%: | $(1)
	$(maketouch)
endef

## Adding to call from elsewhere
$(foreach dir,$(hotdirs),$(eval $(call hotmake,$(dir))))
$(foreach dir,$(colddirs),$(eval $(call coldmake,$(dir))))
