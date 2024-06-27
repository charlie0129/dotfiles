CSRC    = $(shell grep -Rl -e "^int main" src | sed 's_src/__')
CBIN    = $(CSRC:%.c=custom/%)
CC      = gcc
CFLAGS  = -O2 -MMD
LDFLAGS = 
RM      = rm -f
RMR     = rm -rf

all: $(CBIN)

# build C binaries
$(CBIN): custom/%: src/%.c 
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)

clean:
	$(RM) $(CBIN)

-include $(CBIN:%=%.d)
