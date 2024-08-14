# files of NVBoard
NVBOARD_SRC = $(NVBOARD_HOME)/src
NVBOARD_SRCS := $(shell find $(NVBOARD_SRC) -name "*.cpp")
NVBOARD_INC = $(NVBOARD_HOME)/include
NVBOARD_USR_INC = $(NVBOARD_HOME)/usr/include
INC_PATH += $(NVBOARD_USR_INC)

NVBOARD_BUILD_DIR = $(NVBOARD_HOME)/build
NVBOARD_OBJS := $(addprefix $(NVBOARD_BUILD_DIR)/, $(addsuffix .o, $(basename $(notdir $(NVBOARD_SRCS)))))

# The archive of NVBoard
NVBOARD_ARCHIVE = $(NVBOARD_BUILD_DIR)/nvboard.a
CXXFLAGS += -MMD -O3 $(shell sdl2-config --cflags) -g

$(NVBOARD_BUILD_DIR)/%.o: $(NVBOARD_SRC)/%.cpp
	@echo + CXX "->" NVBOARD_HOME/$(shell realpath $< --relative-to $(NVBOARD_HOME))
	@mkdir -p $(dir $@)
	@$(CXX) -I$(NVBOARD_INC) $(CXXFLAGS) -c -o $@ $<

# Build the archive of NVBoard
$(NVBOARD_ARCHIVE): $(NVBOARD_OBJS)
	@echo + AR "->" $(shell realpath $@ --relative-to $(NVBOARD_HOME))
	@ar rcs $(NVBOARD_ARCHIVE) $(NVBOARD_OBJS)

# Rule (`#include` dependencies): paste in `.d` files generated by gcc on `-MMD`
-include $(NVBOARD_OBJS:.o=.d)

# Link flags for examples
LDFLAGS += $(shell sdl2-config --libs) -lSDL2_image -lSDL2_ttf

.PHONY: nvboard-archive nvboard-clean

nvboard-archive: $(NVBOARD_ARCHIVE)

nvboard-clean:
	rm -rf $(NVBOARD_BUILD_DIR)
