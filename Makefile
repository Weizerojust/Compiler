CC := gcc
CFLAGS := -lfl -ly -I./include -std=gnu11 -g
CSOURCE := src/AST.c src/semantic.c src/common.c src/rb_tree.c src/sym_table.c src/ir.c
BFLAGS := -d -v --locations
PARSER := out/parser

parser: src/syntax.y src/lexical.l src/parser.c src/AST.c
	@mkdir -p out
	flex -o out/lex.yy.c src/lexical.l
	bison src/syntax.y $(BFLAGS) -o out/syntax.tab.c
	$(CC) out/syntax.tab.c src/parser.c $(CSOURCE) $(CFLAGS) -o $(PARSER)

ir: src/gen_ir.c $(CSOURCE)
	@mkdir -p out
	flex -o out/lex.yy.c src/lexical.l
	bison src/syntax.y $(BFLAGS) -o out/syntax.tab.c
	$(CC) out/syntax.tab.c src/gen_ir.c $(CSOURCE) $(CFLAGS) -o out/ir

ir-test: 
	out/ir $(TESTCASE)

TESTCASE := test/ir/test1.c
test: parser
	$(PARSER) $(TESTCASE)

test-gcc:
	gcc -x c $(TESTCASE) > /dev/null

testall: parser
	@python3 test.py $(PARSER) test/semantic_test

clean:
	@$(RM) -r out

.PHONY: clean testall
