//===-- StringExtras.cpp - Implement the StringExtras header --------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file implements the StringExtras.h header
//
//===----------------------------------------------------------------------===//

#include "llvm/ADT/StringExtras.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/Support/raw_ostream.h"
#include <cctype>

using namespace llvm;

/// getToken - This function extracts one token from source, ignoring any
/// leading characters that appear in the Delimiters string, and ending the
/// token at any of the characters that appear in the Delimiters string.  If
/// there are no tokens in the source string, an empty string is returned.
/// The function returns a pair containing the extracted token and the
/// remaining tail string.
std::pair<StringRef, StringRef> llvm::getToken(StringRef Source,
                                               StringRef Delimiters) {
  // Figure out where the token starts.
  StringRef::size_type Start = Source.find_first_not_of(Delimiters);

  // Find the next occurrence of the delimiter.
  StringRef::size_type End = Source.find_first_of(Delimiters, Start);

  return {Source.slice(Start, End), Source.substr(End)};
}

/// SplitString - Split up the specified string according to the specified
/// delimiters, appending the result fragments to the output list.
void llvm::SplitString(StringRef Source,
                       SmallVectorImpl<StringRef> &OutFragments,
                       StringRef Delimiters) {
  std::pair<StringRef, StringRef> S = getToken(Source, Delimiters);
  while (!S.first.empty()) {
    OutFragments.push_back(S.first);
    S = getToken(S.second, Delimiters);
  }
}

void llvm::printEscapedString(StringRef Name, raw_ostream &Out) {
  for (size_t i = 0, e = Name.size(); i < e; ++i) {
    unsigned char C = Name[i];
    if (C == '\\') {
      Out << '\\' << C;
    } else if (C >= 0x20 && C < 0x7F && C != '"') {
      Out << C;
    } else if (C >= 0x80) {
      // 若此处开始一个合法的 UTF-8 多字节序列，则原样输出（使 .ll 中出现真实中文）；
      // 否则按字节转义，保证二进制/非法序列可精确往返。
      unsigned Len = 0;
      if ((C & 0xE0) == 0xC0 && C >= 0xC2)
        Len = 2;
      else if ((C & 0xF0) == 0xE0)
        Len = 3;
      else if ((C & 0xF8) == 0xF0 && C <= 0xF4)
        Len = 4;
      bool 合法 = Len != 0 && i + Len <= e;
      if (合法)
        for (unsigned k = 1; k < Len; ++k)
          if ((static_cast<unsigned char>(Name[i + k]) & 0xC0) != 0x80) {
            合法 = false;
            break;
          }
      if (合法) {
        Out.write(Name.data() + i, Len);
        i += Len - 1;
      } else {
        Out << '\\' << hexdigit(C >> 4) << hexdigit(C & 0x0F);
      }
    } else {
      Out << '\\' << hexdigit(C >> 4) << hexdigit(C & 0x0F);
    }
  }
}

void llvm::printHTMLEscaped(StringRef String, raw_ostream &Out) {
  for (char C : String) {
    if (C == '&')
      Out << "&amp;";
    else if (C == '<')
      Out << "&lt;";
    else if (C == '>')
      Out << "&gt;";
    else if (C == '\"')
      Out << "&quot;";
    else if (C == '\'')
      Out << "&apos;";
    else
      Out << C;
  }
}

void llvm::printLowerCase(StringRef String, raw_ostream &Out) {
  for (const char C : String)
    Out << toLower(C);
}

void llvm::printPercentEncoded(StringRef String, raw_ostream &Out) {
  for (unsigned char C : String) {
    if (isAlnum(C) || StringRef("-_.~").contains(C))
      Out << C;
    else
      Out << '%' << hexdigit(C >> 4) << hexdigit(C & 0x0F);
  }
}

std::string llvm::convertToSnakeFromCamelCase(StringRef input) {
  if (input.empty())
    return "";

  std::string snakeCase;
  snakeCase.reserve(input.size());
  auto check = [&input](size_t j, function_ref<bool(int)> predicate) {
    return j < input.size() && predicate(input[j]);
  };
  for (size_t i = 0; i < input.size(); ++i) {
    snakeCase.push_back(tolower(input[i]));
    // Handles "runs" of capitals, such as in OPName -> op_name.
    if (check(i, isupper) && check(i + 1, isupper) && check(i + 2, islower))
      snakeCase.push_back('_');
    if ((check(i, islower) || check(i, isdigit)) && check(i + 1, isupper))
      snakeCase.push_back('_');
  }
  return snakeCase;
}

std::string llvm::convertToCamelFromSnakeCase(StringRef input,
                                              bool capitalizeFirst) {
  if (input.empty())
    return "";

  std::string output;
  output.reserve(input.size());

  // Push the first character, capatilizing if necessary.
  if (capitalizeFirst && std::islower(input.front()))
    output.push_back(llvm::toUpper(input.front()));
  else
    output.push_back(input.front());

  // Walk the input converting any `*_[a-z]` snake case into `*[A-Z]` camelCase.
  for (size_t pos = 1, e = input.size(); pos < e; ++pos) {
    if (input[pos] == '_' && pos != (e - 1) && std::islower(input[pos + 1]))
      output.push_back(llvm::toUpper(input[++pos]));
    else
      output.push_back(input[pos]);
  }
  return output;
}
