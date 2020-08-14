
%.makejobs: /proc/uptime
	- ssh $* "cd $(CURDIR); echo $* > $@;  ps aux | grep make | grep -v grep >> $@"

node_makejobs = $(nodes:%=%.makejobs)

Ignore += *.makejobs
nodes.makejobs: $(node_makejobs)
	$(cat)

%.remotetarget:
	ssh -f $* "cd $(CURDIR) && $(MAKE) $*_target > $*.remotelog" 

Ignore += *.remotelog
define remotemake
%.$(1): 
	ssh -f $(1) "cd $(CURDIR) && $(MAKE) $$* > $$*.$(1).remotelog" 
endef

$(foreach node,$(nodes),$(eval $(call remotemake,$(node))))
 
