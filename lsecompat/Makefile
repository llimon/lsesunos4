# ==============================================================================
# Makefile for lse-compat (SunOS 4 / POSIX Compatibility Library)
# ==============================================================================

# Installation Directories
prefix      ?= /usr/local/lse
INCDIR       = $(prefix)/include
LSE_INCDIR   = $(INCDIR)/lse
LIBDIR       = $(prefix)/lib

# Compiler Toolchain
CC          = gcc
AR          ?= ar
RANLIB      ?= ranlib
RM           = rm -f

# Default Flags (Appended with user-supplied flags)
BASE_CFLAGS  = -O2 -mcpu=v7
ALL_CFLAGS   = $(BASE_CFLAGS) $(CFLAGS)
ALL_CPPFLAGS = -I. -I$(INCDIR) $(CPPFLAGS)

# Source Definitions
LSECOMPAT_SRCS = strtoimax_compat.c \
                 ftello_compat.c \
                 snprintf_compat.c \
                 getprogname_compat.c \
                 usleep_compat.c \
                 utimes_compat.c \
                 math_compat.c \
                 string_compat.c

LSENET_SRCS    = dns_rfc2553_compat.c \
                 socket_compat.c

# Object Files
LSECOMPAT_OBJS = $(LSECOMPAT_SRCS:.c=.o)
LSENET_OBJS    = $(LSENET_SRCS:.c=.o)

# Static Libraries
LIB_LSECOMPAT  = liblsecompat.a
LIB_LSENET     = liblsenet.a

# Header Classifications
# 1. Top-Level Headers -> $(prefix)/include
HEADERS_TOP    = lsecompat.h lsenet.h stdint.h inttypes.h

# 2. Internal Component Headers -> $(prefix)/include/lse
HEADERS_LSE    = string_compat.h \
                 snprintf_compat.h \
                 math_compat.h \
                 strtoimax_compat.h \
                 ftello_compat.h \
                 getprogname_compat.h \
                 usleep_compat.h \
                 utimes_compat.h \
                 dns_rfc2553_compat.h \
                 socket_compat.h

# ------------------------------------------------------------------------------
# Targets
# ------------------------------------------------------------------------------

all: $(LIB_LSECOMPAT) $(LIB_LSENET)

# Build liblsecompat.a
$(LIB_LSECOMPAT): $(LSECOMPAT_OBJS)
	@echo "=== Creating $@ ==="
	$(RM) $@
	$(AR) cr $@ $(LSECOMPAT_OBJS)
	@echo "Indexing $@ with $(RANLIB)..."
	$(RANLIB) $@

# Build liblsenet.a
$(LIB_LSENET): $(LSENET_OBJS)
	@echo "=== Creating $@ ==="
	$(RM) $@
	$(AR) cr $@ $(LSENET_OBJS)
	@echo "Indexing $@ with $(RANLIB)..."
	$(RANLIB) $@

# Special compilation rule for snprintf_compat.c (if defines are needed in the future)
snprintf_compat.o: snprintf_compat.c
	$(CC) $(ALL_CPPFLAGS) $(SNPRINTF_DEFS) $(ALL_CFLAGS) -c $< -o $@

# Generic pattern rule for object files
%.o: %.c
	$(CC) $(ALL_CPPFLAGS) $(ALL_CFLAGS) -c $< -o $@

# ------------------------------------------------------------------------------
# Install Target
# ------------------------------------------------------------------------------

install: all
	@echo "=== Installing headers and libraries to $(prefix) ==="
	@if [ ! -d $(INCDIR) ]; then mkdir -p $(INCDIR); fi
	@if [ ! -d $(LSE_INCDIR) ]; then mkdir -p $(LSE_INCDIR); fi
	@if [ ! -d $(LIBDIR) ]; then mkdir -p $(LIBDIR); fi
	
	# 1. Install Top-Level Headers (lsecompat.h, lsenet.h, stdint.h, inttypes.h)
	@for h in $(HEADERS_TOP); do \
		if [ -f $$h ]; then \
			echo "Installing $$h -> $(INCDIR)/$$h"; \
			cp $$h $(INCDIR)/$$h; \
			chmod 644 $(INCDIR)/$$h; \
		fi; \
	done
	
	# 2. Install Individual Component Headers -> $(INCDIR)/lse/
	@for h in $(HEADERS_LSE); do \
		if [ -f $$h ]; then \
			echo "Installing $$h -> $(LSE_INCDIR)/$$h"; \
			cp $$h $(LSE_INCDIR)/$$h; \
			chmod 644 $(LSE_INCDIR)/$$h; \
		fi; \
	done

	# 3. Install Static Archives
	cp $(LIB_LSECOMPAT) $(LIB_LSENET) $(LIBDIR)/
	chmod 644 $(LIBDIR)/$(LIB_LSECOMPAT) $(LIBDIR)/$(LIB_LSENET)
	$(RANLIB) $(LIBDIR)/$(LIB_LSECOMPAT)
	$(RANLIB) $(LIBDIR)/$(LIB_LSENET)
	@echo "=== Installation complete ==="

# ------------------------------------------------------------------------------
# Clean Target
# ------------------------------------------------------------------------------

clean:
	$(RM) *.o $(LIB_LSECOMPAT) $(LIB_LSENET)

.PHONY: all install clean
