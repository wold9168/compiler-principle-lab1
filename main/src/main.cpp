#include "main/main.hpp"

int main(int argc, char **argv) {
  if (argc != 1) {
    std::cerr << "Usage: ./main <input_file>" << std::endl;
    return 1;
  }
  std::ifstream input(argv[1]);
  if (!input.is_open()) {
    std::cerr << "Error opening file: " << argv[1] << std::endl;
    return 1;
  }
  v.push_back(42);
}