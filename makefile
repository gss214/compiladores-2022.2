CXX=gcc

CFLAGS=-std=gnu99
DEBUGFLAGS=-Wall -g -fsanitize=address -fno-omit-frame-pointer

TARGET ?= Run
TEST ?= Test

BUILD_DIR ?= build
OUT_DIR ?= out
SRC_DIR ?= src
MKDIR_P ?= mkdir -p

$(TARGET):
	$(MKDIR_P) $(BUILD_DIR) $(OUT_DIR)
	flex -o $(BUILD_DIR)/lexico.c $(SRC_DIR)/lexico/lexico.l
	yacc -o $(BUILD_DIR)/sintatico.c -d $(SRC_DIR)/sintatico/sintatico.y
	$(CXX) $(DEBUGFLAGS) $(CFLAGS) $(SRC_DIR)/main.c $(BUILD_DIR)/lexico.c $(BUILD_DIR)/sintatico.c -o $@
	
test:
	$(MKDIR_P) $(BUILD_DIR) $(OUT_DIR)
	flex -o $(BUILD_DIR)/lexico.c $(SRC_DIR)/lexico/lexico.l
	yacc -o $(BUILD_DIR)/sintatico.c -d $(SRC_DIR)/sintatico/sintatico.y
	$(CXX) $(DEBUGFLAGS) $(CFLAGS) $(SRC_DIR)/test.c $(BUILD_DIR)/lexico.c $(BUILD_DIR)/sintatico.c -o $(TEST)

.PHONY: clean
clean:
	$(RM) -r $(BUILD_DIR) $(OUT_DIR) $(TARGET) $(TEST)
