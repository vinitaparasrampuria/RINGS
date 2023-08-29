all: setup.ipynb

clean:
	rm setup.ipynb




SNIPPETS := custom-snippets/intro.md
SNIPPETS += custom-snippets/random-vars.md 
SNIPPETS += custom-snippets/as-defs.md 
SNIPPETS += custom-snippets/reserve-resources.md 
SNIPPETS += fabric-snippets/configure-resources.md 
SNIPPETS += custom-snippets/setup-frr.md 
SNIPPETS += custom-snippets/draw-topo.md 
SNIPPETS += fabric-snippets/log-in.md 
SNIPPETS += fabric-snippets/delete-slice.md

setup.ipynb: $(SNIPPETS) 
	pandoc --wrap=none \
                -i custom-snippets/intro.md \
                custom-snippets/random-vars.md \
				custom-snippets/as-defs.md \
				custom-snippets/reserve-resources.md \
                fabric-snippets/configure-resources.md \
				custom-snippets/setup-frr.md \
				custom-snippets/draw-topo.md \
				fabric-snippets/log-in.md \
				fabric-snippets/delete-slice.md \
                -o setup.ipynb  
