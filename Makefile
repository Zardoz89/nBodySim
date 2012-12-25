DC=gdc
PARALLELISM= -fversion=PFor
DFLAGS= -Wall -o2 $(PARALLELISM)
LDFLAGS=


EXE = nBodySim

.PHONY: clean

all: $(EXE)


nBodySim: simulator.d entity.d vector.d
	$(DC) $(DFLAGS) simulator.d entity.d vector.d -o nBodySim $(LDFLAGS)

clean:
	rm -f core $(EXE) 
