$(foreach target,$(notdir $(wildcard git_cache/*.Rout)),$(eval git_cache/$(target): $(target)))

