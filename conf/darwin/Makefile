MAKEFLAGS += -s --always-make

SCRIPTS = $(patsubst %.sh, %, $(wildcard *.sh))

all: $(SCRIPTS)

$(SCRIPTS):
	bash $@.sh