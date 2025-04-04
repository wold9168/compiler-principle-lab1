#include "main/main.hpp"
#include "parser/parser.hpp"

int main(int argc, char **argv) {
  if (argc < 2) {
    std::cerr << "Usage: ./main <input_file>" << std::endl;
    return 1;
  }
  // FILE *fp;
  if(!(yyin=fopen(argv[1], "r"))) {
    std::cerr << "Error: Could not open input file." << std::endl;
    return 1;
  }
  yyrestart(yyin);
  yyparse();
  // global_token_list.traverse();
  if(isNoError)
    preordered_traverse(root);
}