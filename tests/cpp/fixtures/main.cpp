#include "sample.hpp"
#include <vector>
int main() {
  const int answer = answer_value();
  std::vector<int> values{answer};
  return values.front() == 42 ? 0 : 1;
}
