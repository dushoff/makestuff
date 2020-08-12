
## Move this to a cluster-specific file, maybe?
nodes = n01 n02 n03 n04 n05

%.makejobs: /proc/uptime
	- ssh $* "cd $(CURDIR); echo $* > $@;  ps aux | grep make | grep -v grep >> $@"

node_makejobs = $(nodes:%=%.makejobs)

nodes.makejobs: $(node_makejobs)
	$(cat)

%.remotetarget:
	ssh -f $* "cd $(CURDIR) && $(MAKE) $*_target > $*.remotelog" 

define remotemake
%.$(1): 
	ssh -f $(1) "cd $(CURDIR) && $(MAKE) $$* > $$*.$(1).log" 
endef

$(foreach node,$(nodes),$(eval $(call remotemake,$(node))))
 
