CXX=gcc

CFLAGS=-std=c11

TARGET ?= Run

BUILD_DIR ?= build
SRC_DIR ?= src

$(TARGET):
	$(MKDIR_P) $(BUILD_DIR)
	flex -o $(BUILD_DIR)/lexico.c $(SRC_DIR)/lexico/lexico.l
	yacc -o $(BUILD_DIR)/sintatico.c -d $(SRC_DIR)/sintatico/sintatico.y
	$(CXX) $(CFLAGS) $(SRC_DIR)/main.c $(BUILD_DIR)/lexico.c $(BUILD_DIR)/sintatico.c -o $@

.PHONY: clean
clean:
	$(RM) -r $(BUILD_DIR) $(TARGET)

MKDIR_P ?= mkdir -p