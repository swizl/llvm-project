//===--- Builtins.cpp - Builtin function implementation -------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
//  This file implements various things for builtin functions.
//
//===----------------------------------------------------------------------===//

#include "clang/Basic/Builtins.h"
#include "BuiltinTargetFeatures.h"
#include "clang/Basic/IdentifierTable.h"
#include "clang/Basic/LangOptions.h"
#include "clang/Basic/TargetInfo.h"
#include "llvm/ADT/SmallString.h"
#include "llvm/ADT/StringMap.h"
#include "llvm/ADT/StringRef.h"
using namespace clang;

// Chinese builtin alias registry (中文内置函数别名表).
// Maps a Chinese alias identifier (e.g. "打印") to the canonical libc symbol
// name (e.g. "printf"). Used during code generation so that calls through an
// alias lower to the real library symbol rather than an external symbol named
// after the Chinese identifier.
static llvm::StringMap<std::string> &getChineseBuiltinAliasMap() {
  static llvm::StringMap<std::string> Map;
  return Map;
}

/// If \p Name is a registered Chinese alias for a libc builtin, return the
/// canonical symbol name ("printf", "malloc", ...); otherwise return an empty
/// StringRef.
StringRef clang::getCanonicalNameForChineseBuiltin(StringRef Name) {
  auto &Map = getChineseBuiltinAliasMap();
  auto It = Map.find(Name);
  if (It == Map.end())
    return {};
  return It->second;
}

const char *HeaderDesc::getName() const {
  switch (ID) {
#define HEADER(ID, NAME)                                                       \
  case ID:                                                                     \
    return NAME;
#include "clang/Basic/BuiltinHeaders.def"
#undef HEADER
  };
  llvm_unreachable("Unknown HeaderDesc::HeaderID enum");
}

static constexpr unsigned NumBuiltins = Builtin::FirstTSBuiltin;

#define GET_BUILTIN_STR_TABLE
#include "clang/Basic/Builtins.inc"
#undef GET_BUILTIN_STR_TABLE

static constexpr Builtin::Info BuiltinInfos[] = {
    Builtin::Info{}, // No-builtin info entry.
#define GET_BUILTIN_INFOS
#include "clang/Basic/Builtins.inc"
#undef GET_BUILTIN_INFOS
};
static_assert(std::size(BuiltinInfos) == NumBuiltins);

std::pair<const Builtin::InfosShard &, const Builtin::Info &>
Builtin::Context::getShardAndInfo(unsigned ID) const {
  assert((ID < (Builtin::FirstTSBuiltin + NumTargetBuiltins +
                NumAuxTargetBuiltins)) &&
         "Invalid builtin ID!");

  ArrayRef<InfosShard> Shards = BuiltinShards;
  if (isAuxBuiltinID(ID)) {
    Shards = AuxTargetShards;
    ID = getAuxBuiltinID(ID) - Builtin::FirstTSBuiltin;
  } else if (ID >= Builtin::FirstTSBuiltin) {
    Shards = TargetShards;
    ID -= Builtin::FirstTSBuiltin;
  }

  // Loop over the shards to find the one matching this ID. We don't expect to
  // have many shards and so its better to search linearly than with a binary
  // search.
  for (const auto &Shard : Shards) {
    if (ID < Shard.Infos.size()) {
      return {Shard, Shard.Infos[ID]};
    }

    ID -= Shard.Infos.size();
  }
  llvm_unreachable("Invalid target builtin shard structure!");
}

/// Return a non-owning StringRef of the builtin's name, reconstructed into Buf.
static StringRef getBuiltinNameInto(const Builtin::InfosShard &Shard,
                                    const Builtin::Info &BuiltinInfo,
                                    SmallVectorImpl<char> &Buf) {
  StringRef Name = (*Shard.Strings)[BuiltinInfo.Offsets.Name];
  if (Shard.NamePrefix.empty())
    return Name;
  Buf.assign(Shard.NamePrefix.begin(), Shard.NamePrefix.end());
  Buf.append(Name.begin(), Name.end());
  return StringRef(Buf.data(), Buf.size());
}

std::string Builtin::Info::getName(const Builtin::InfosShard &Shard) const {
  SmallString<256> Buf;
  return getBuiltinNameInto(Shard, *this, Buf).str();
}

/// Return the identifier name for the specified builtin,
/// e.g. "__builtin_abs".
std::string Builtin::Context::getName(unsigned ID) const {
  const auto &[Shard, I] = getShardAndInfo(ID);
  return I.getName(Shard);
}

std::string Builtin::Context::getQuotedName(unsigned ID) const {
  const auto &[Shard, I] = getShardAndInfo(ID);
  return (Twine("'") + Shard.NamePrefix + (*Shard.Strings)[I.Offsets.Name] +
          "'")
      .str();
}

const char *Builtin::Context::getTypeString(unsigned ID) const {
  const auto &[Shard, I] = getShardAndInfo(ID);
  return (*Shard.Strings)[I.Offsets.Type].data();
}

const char *Builtin::Context::getAttributesString(unsigned ID) const {
  const auto &[Shard, I] = getShardAndInfo(ID);
  return (*Shard.Strings)[I.Offsets.Attributes].data();
}

const char *Builtin::Context::getRequiredFeatures(unsigned ID) const {
  const auto &[Shard, I] = getShardAndInfo(ID);
  return (*Shard.Strings)[I.Offsets.Features].data();
}

Builtin::Context::Context() : BuiltinShards{{&BuiltinStrings, BuiltinInfos}} {}

void Builtin::Context::InitializeTarget(const TargetInfo &Target,
                                        const TargetInfo *AuxTarget) {
  assert(TargetShards.empty() && "Already initialized target?");
  assert(NumTargetBuiltins == 0 && "Already initialized target?");
  TargetShards = Target.getTargetBuiltins();
  for (const auto &Shard : TargetShards)
    NumTargetBuiltins += Shard.Infos.size();
  if (AuxTarget) {
    AuxTargetShards = AuxTarget->getTargetBuiltins();
    for (const auto &Shard : AuxTargetShards)
      NumAuxTargetBuiltins += Shard.Infos.size();
  }
}

bool Builtin::Context::isBuiltinFunc(llvm::StringRef FuncName) {
  bool InStdNamespace = FuncName.consume_front("std-");
  for (const auto &Shard : {InfosShard{&BuiltinStrings, BuiltinInfos}})
    if (llvm::StringRef FuncNameSuffix = FuncName;
        FuncNameSuffix.consume_front(Shard.NamePrefix))
      for (const auto &I : Shard.Infos)
        if (FuncNameSuffix == (*Shard.Strings)[I.Offsets.Name] &&
            (bool)strchr((*Shard.Strings)[I.Offsets.Attributes].data(), 'z') ==
                InStdNamespace)
          return strchr((*Shard.Strings)[I.Offsets.Attributes].data(), 'f') !=
                 nullptr;

  return false;
}

/// Is this builtin supported according to the given language options?
static bool builtinIsSupported(const llvm::StringTable &Strings,
                               const Builtin::Info &BuiltinInfo,
                               const LangOptions &LangOpts) {
  auto AttributesStr = Strings[BuiltinInfo.Offsets.Attributes];

  /* Builtins Unsupported */
  if (LangOpts.NoBuiltin && strchr(AttributesStr.data(), 'f') != nullptr)
    return false;
  /* CorBuiltins Unsupported */
  if (!LangOpts.Coroutines && (BuiltinInfo.Langs & COR_LANG))
    return false;
  /* MathBuiltins Unsupported */
  if (LangOpts.NoMathBuiltin && BuiltinInfo.Header.ID == HeaderDesc::MATH_H)
    return false;
  /* GnuMode Unsupported */
  if (!LangOpts.GNUMode && (BuiltinInfo.Langs & GNU_LANG))
    return false;
  /* MSMode Unsupported */
  if (!LangOpts.MicrosoftExt && (BuiltinInfo.Langs & MS_LANG))
    return false;
  /* HLSLMode Unsupported */
  if (!LangOpts.HLSL && (BuiltinInfo.Langs & HLSL_LANG))
    return false;
  /* ObjC Unsupported */
  if (!LangOpts.ObjC && BuiltinInfo.Langs == OBJC_LANG)
    return false;
  /* OpenCLC Unsupported */
  if (!LangOpts.OpenCL && (BuiltinInfo.Langs & ALL_OCL_LANGUAGES))
    return false;
  /* OpenCL GAS Unsupported */
  if (!LangOpts.OpenCLGenericAddressSpace && (BuiltinInfo.Langs & OCL_GAS))
    return false;
  /* OpenCL Pipe Unsupported */
  if (!LangOpts.OpenCLPipes && (BuiltinInfo.Langs & OCL_PIPE))
    return false;

  // Device side enqueue is not supported until OpenCL 2.0. In 2.0 and higher
  // support is indicated with language option for blocks.

  /* OpenCL DSE Unsupported */
  if ((LangOpts.getOpenCLCompatibleVersion() < 200 || !LangOpts.Blocks) &&
      (BuiltinInfo.Langs & OCL_DSE))
    return false;
  /* OpenMP Unsupported */
  if (!LangOpts.OpenMP && BuiltinInfo.Langs == OMP_LANG)
    return false;
  /* CUDA Unsupported */
  if (!LangOpts.CUDA && BuiltinInfo.Langs == CUDA_LANG)
    return false;
  /* CPlusPlus Unsupported */
  if (!LangOpts.CPlusPlus && BuiltinInfo.Langs == CXX_LANG)
    return false;
  /* consteval Unsupported */
  if (!LangOpts.CPlusPlus20 && strchr(AttributesStr.data(), 'G') != nullptr)
    return false;
  /* C23 unsupported */
  if (!LangOpts.C23 && BuiltinInfo.Langs == C23_LANG)
    return false;
  /* C2y unsupported */
  if (!LangOpts.C2y && BuiltinInfo.Langs == C2Y_LANG)
    return false;
  return true;
}

static bool isBuiltinConstForTriple(unsigned BuiltinID, llvm::Triple Trip) {
  // There's a special case with the fma builtins where they are always const
  // if the target environment is GNU or the target is OS is Windows and we're
  // targeting the MSVCRT.dll environment.
  // FIXME: This list can be become outdated. Need to find a way to get it some
  // other way.
  switch (BuiltinID) {
  case Builtin::BI__builtin_fma:
  case Builtin::BI__builtin_fmaf:
  case Builtin::BI__builtin_fmal:
  case Builtin::BI__builtin_fmaf16:
  case Builtin::BIfma:
  case Builtin::BIfmaf:
  case Builtin::BIfmal: {
    if (Trip.isGNUEnvironment() || Trip.isOSMSVCRT())
      return true;
    break;
  }
  default:
    break;
  }

  return false;
}

bool Builtin::Context::shouldGenerateFPMathIntrinsic(
    unsigned BuiltinID, llvm::Triple Trip, std::optional<bool> ErrnoOverwritten,
    bool MathErrnoEnabled, bool HasOptNoneAttr,
    bool IsOptimizationEnabled) const {

  // True if we are compiling at -O2 and errno has been disabled
  // using the '#pragma float_control(precise, off)', and
  // attribute opt-none hasn't been seen.
  bool ErrnoOverridenToFalseWithOpt = ErrnoOverwritten.has_value() &&
                                      !ErrnoOverwritten.value() &&
                                      !HasOptNoneAttr && IsOptimizationEnabled;

  // There are LLVM math intrinsics/instructions corresponding to math library
  // functions except the LLVM op will never set errno while the math library
  // might. Also, math builtins have the same semantics as their math library
  // twins. Thus, we can transform math library and builtin calls to their
  // LLVM counterparts if the call is marked 'const' (known to never set errno).
  // In case FP exceptions are enabled, the experimental versions of the
  // intrinsics model those.
  bool ConstAlways =
      isConst(BuiltinID) || isBuiltinConstForTriple(BuiltinID, Trip);

  bool ConstWithoutErrnoAndExceptions =
      isConstWithoutErrnoAndExceptions(BuiltinID);
  bool ConstWithoutExceptions = isConstWithoutExceptions(BuiltinID);

  // ConstAttr is enabled in fast-math mode. In fast-math mode, math-errno is
  // disabled.
  // Math intrinsics are generated only when math-errno is disabled. Any pragmas
  // or attributes that affect math-errno should prevent or allow math
  // intrinsics to be generated. Intrinsics are generated:
  //   1- In fast math mode, unless math-errno is overriden
  //      via '#pragma float_control(precise, on)', or via an
  //      'attribute__((optnone))'.
  //   2- If math-errno was enabled on command line but overriden
  //      to false via '#pragma float_control(precise, off))' and
  //      'attribute__((optnone))' hasn't been used.
  //   3- If we are compiling with optimization and errno has been disabled
  //      via '#pragma float_control(precise, off)', and
  //      'attribute__((optnone))' hasn't been used.

  bool ConstWithoutErrnoOrExceptions =
      ConstWithoutErrnoAndExceptions || ConstWithoutExceptions;
  bool GenerateIntrinsics =
      (ConstAlways && !HasOptNoneAttr) ||
      (!MathErrnoEnabled &&
       !(ErrnoOverwritten.has_value() && ErrnoOverwritten.value()) &&
       !HasOptNoneAttr);
  if (!GenerateIntrinsics) {
    GenerateIntrinsics =
        ConstWithoutErrnoOrExceptions && !ConstWithoutErrnoAndExceptions;
    if (!GenerateIntrinsics)
      GenerateIntrinsics =
          ConstWithoutErrnoOrExceptions &&
          (!MathErrnoEnabled &&
           !(ErrnoOverwritten.has_value() && ErrnoOverwritten.value()) &&
           !HasOptNoneAttr);
    if (!GenerateIntrinsics)
      GenerateIntrinsics =
          ConstWithoutErrnoOrExceptions && ErrnoOverridenToFalseWithOpt;
  }

  return GenerateIntrinsics;
}

/// initializeBuiltins - Mark the identifiers for all the builtins with their
/// appropriate builtin ID # and mark any non-portable builtin identifiers as
/// such.
void Builtin::Context::initializeBuiltins(IdentifierTable &Table,
                                          const LangOptions &LangOpts) {
  {
    unsigned ID = 0;
    llvm::SmallString<256> NameBuf;
    // Step #1: mark all target-independent builtins with their ID's.
    for (const auto &Shard : BuiltinShards)
      for (const auto &I : Shard.Infos) {
        // If this is a real builtin (ID != 0) and is supported, add it.
        if (ID != 0 && builtinIsSupported(*Shard.Strings, I, LangOpts))
          Table.get(getBuiltinNameInto(Shard, I, NameBuf)).setBuiltinID(ID);
        ++ID;
      }
    assert(ID == FirstTSBuiltin && "Should have added all non-target IDs!");

    // Step #2: Register target-specific builtins.
    for (const auto &Shard : TargetShards)
      for (const auto &I : Shard.Infos) {
        if (builtinIsSupported(*Shard.Strings, I, LangOpts))
          Table.get(getBuiltinNameInto(Shard, I, NameBuf)).setBuiltinID(ID);
        ++ID;
      }

    // Step #3: Register target-specific builtins for AuxTarget.
    for (const auto &Shard : AuxTargetShards)
      for (const auto &I : Shard.Infos) {
        Table.get(getBuiltinNameInto(Shard, I, NameBuf)).setBuiltinID(ID);
        ++ID;
      }
  }

  // Step #4: Unregister any builtins specified by -fno-builtin-foo.
  for (llvm::StringRef Name : LangOpts.NoBuiltinFuncs) {
    bool InStdNamespace = Name.consume_front("std-");
    auto NameIt = Table.find(Name);
    if (NameIt != Table.end()) {
      unsigned ID = NameIt->second->getBuiltinID();
      if (ID != Builtin::NotBuiltin && isPredefinedLibFunction(ID) &&
          isInStdNamespace(ID) == InStdNamespace) {
        NameIt->second->clearBuiltinID();
      }
    }
  }

  // Step #5: Register Chinese aliases for common builtins (中文内置函数别名)
  auto &AliasMap = getChineseBuiltinAliasMap();
  auto RegAlias = [&](const char *Chinese, const char *English) {
    auto It = Table.find(English);
    if (It == Table.end() ||
        It->second->getBuiltinID() == Builtin::NotBuiltin)
      return;
    unsigned BID = It->second->getBuiltinID();
    Table.get(Chinese).setBuiltinID(BID);
    // Record the canonical identifier/symbol name for the Sema rewrite and
    // code generation. Only strip the "__builtin_" prefix for aliases of
    // real predefined libc functions (e.g. "__builtin_memcpy" -> "memcpy");
    // compiler intrinsics like "__builtin_expect" have no libc counterpart
    // and keep the prefix.
    StringRef Canonical(English);
    if (Canonical.starts_with("__builtin_") &&
        isPredefinedLibFunction(BID))
      Canonical = Canonical.substr(strlen("__builtin_"));
    AliasMap[Chinese] = Canonical.str();
  };
  // Input/Output (输入输出)
  RegAlias("打印", "printf");
  RegAlias("格式化打印", "printf");
  RegAlias("扫描", "scanf");
  RegAlias("格式化扫描", "scanf");
  RegAlias("文件打印", "fprintf");
  RegAlias("文件扫描", "fscanf");
  RegAlias("格式化字符串", "sprintf");
  RegAlias("格式化字符串n", "snprintf");
  // Memory (内存)
  RegAlias("分配", "malloc");
  RegAlias("重新分配", "realloc");
  RegAlias("分配并清零", "calloc");
  RegAlias("释放", "free");
  RegAlias("内存复制", "memcpy");
  RegAlias("内存移动", "memmove");
  RegAlias("内存设置", "memset");
  RegAlias("内存比较", "memcmp");
  // String (字符串)
  RegAlias("字符串长度", "strlen");
  RegAlias("字符串复制", "strcpy");
  RegAlias("字符串复制n", "strncpy");
  RegAlias("字符串连接", "strcat");
  RegAlias("字符串比较", "strcmp");
  RegAlias("字符串查找", "strchr");
  RegAlias("字符串查找子串", "strstr");
  // Math (数学)
  RegAlias("平方根", "sqrt");
  RegAlias("绝对值", "abs");
  RegAlias("浮点绝对值", "fabs");
  RegAlias("幂运算", "pow");
  RegAlias("正弦", "sin");
  RegAlias("余弦", "cos");
  RegAlias("正切", "tan");
  RegAlias("向上取整", "ceil");
  RegAlias("向下取整", "floor");
  RegAlias("四舍五入", "round");
  RegAlias("截断", "trunc");
  RegAlias("取余", "fmod");
  RegAlias("幂运算2", "exp2");
  RegAlias("对数2", "log2");
  RegAlias("立方根", "cbrt");
  RegAlias("斜边", "hypot");
  RegAlias("反正切2", "atan2");
  RegAlias("双曲正弦", "sinh");
  RegAlias("双曲余弦", "cosh");
  RegAlias("双曲正切", "tanh");
  // Character (字符)
  RegAlias("是字母", "isalpha");
  RegAlias("是数字", "isdigit");
  RegAlias("是字母数字", "isalnum");
  RegAlias("是空白", "isspace");
  RegAlias("是大写", "isupper");
  RegAlias("是小写", "islower");
  RegAlias("是打印字符", "isprint");
  RegAlias("是标点", "ispunct");
  RegAlias("是十六进制", "isxdigit");
  RegAlias("是控制字符", "iscntrl");
  RegAlias("是图形字符", "isgraph");
  RegAlias("转大写", "toupper");
  RegAlias("转小写", "tolower");
  // Type conversion (类型转换)
  RegAlias("转整数", "atoi");
  RegAlias("转长整数", "atol");
  RegAlias("转浮点", "atof");
  RegAlias("转长整数扩展", "strtol");
  RegAlias("转无符号长整数", "strtoul");
  // Program control (程序控制)
  RegAlias("退出", "exit");
  RegAlias("中止", "abort");
  RegAlias("注册退出", "atexit");
  RegAlias("系统调用", "system");
  RegAlias("获取环境", "getenv");
  // Sorting and searching (排序和查找)
  RegAlias("快速排序", "qsort");
  RegAlias("二分查找", "bsearch");
  // Random (随机数)
  RegAlias("随机数", "rand");
  RegAlias("设置种子", "srand");
  // Compiler builtins (编译器内置)
  RegAlias("预期", "__builtin_expect");
  RegAlias("不可达", "__builtin_unreachable");
  RegAlias("陷阱", "__builtin_trap");
  RegAlias("恒假", "__builtin_assume");
  RegAlias("静态断言内置", "__builtin_static_assert");
  RegAlias("类型检查", "__builtin_types_compatible_p");
  RegAlias("常量检查", "__builtin_constant_p");
  RegAlias("选择", "__builtin_choose_expr");
  RegAlias("偏移量", "__builtin_offsetof");
  RegAlias("内联预期", "__builtin_expect_with_probability");
  RegAlias("内存复制内置", "__builtin_memcpy");
  RegAlias("内存设置内置", "__builtin_memset");
  RegAlias("内存移动内置", "__builtin_memmove");
  RegAlias("字符串长度内置", "__builtin_strlen");
  RegAlias("陷阱", "__builtin_debugtrap");
  RegAlias("断点", "__builtin_debugtrap");
}

unsigned Builtin::Context::getRequiredVectorWidth(unsigned ID) const {
  const char *WidthPos = ::strchr(getAttributesString(ID), 'V');
  if (!WidthPos)
    return 0;

  ++WidthPos;
  assert(*WidthPos == ':' &&
         "Vector width specifier must be followed by a ':'");
  ++WidthPos;

  char *EndPos;
  unsigned Width = ::strtol(WidthPos, &EndPos, 10);
  assert(*EndPos == ':' && "Vector width specific must end with a ':'");
  return Width;
}

bool Builtin::Context::isLike(unsigned ID, unsigned &FormatIdx,
                              bool &HasVAListArg, const char *Fmt) const {
  assert(Fmt && "Not passed a format string");
  assert(::strlen(Fmt) == 2 &&
         "Format string needs to be two characters long");
  assert(::toupper(Fmt[0]) == Fmt[1] &&
         "Format string is not in the form \"xX\"");

  const char *Like = ::strpbrk(getAttributesString(ID), Fmt);
  if (!Like)
    return false;

  HasVAListArg = (*Like == Fmt[1]);

  ++Like;
  assert(*Like == ':' && "Format specifier must be followed by a ':'");
  ++Like;

  assert(::strchr(Like, ':') && "Format specifier must end with a ':'");
  FormatIdx = ::strtol(Like, nullptr, 10);
  return true;
}

bool Builtin::Context::isPrintfLike(unsigned ID, unsigned &FormatIdx,
                                    bool &HasVAListArg) {
  return isLike(ID, FormatIdx, HasVAListArg, "pP");
}

bool Builtin::Context::isScanfLike(unsigned ID, unsigned &FormatIdx,
                                   bool &HasVAListArg) {
  return isLike(ID, FormatIdx, HasVAListArg, "sS");
}

static void parseCommaSeparatedIndices(const char *CurrPos,
                                       llvm::SmallVectorImpl<int> &Indxs) {
  assert(*CurrPos == '<' && "Expected '<' to start index list");
  ++CurrPos;

  char *EndPos;
  int PosIdx = ::strtol(CurrPos, &EndPos, 10);
  assert(PosIdx >= 0 && "Index is supposed to be positive!");
  Indxs.push_back(PosIdx);

  while (*EndPos == ',') {
    const char *PayloadPos = EndPos + 1;

    int PayloadIdx = ::strtol(PayloadPos, &EndPos, 10);
    Indxs.push_back(PayloadIdx);
  }

  assert(*EndPos == '>' && "Index list must end with '>'");
}

bool Builtin::Context::isNonNull(unsigned ID, llvm::SmallVectorImpl<int> &Indxs,
                                 Info::NonNullMode &Mode) const {

  const char *AttrPos = ::strchr(getAttributesString(ID), 'N');
  if (!AttrPos)
    return false;

  ++AttrPos;
  assert(*AttrPos == ':' && "Format specifier must be followed by a ':'");
  ++AttrPos;
  if (*AttrPos == '0')
    Mode = Info::NonNullMode::NonOptimizing;
  else if (*AttrPos == '1')
    Mode = Info::NonNullMode::Optimizing;
  else
    llvm_unreachable("Unrecognized NonNull optimization mode");
  ++AttrPos; // skip mode
  assert(*AttrPos == ':' && "Mode must be followed by a ':'");
  ++AttrPos;

  parseCommaSeparatedIndices(AttrPos, Indxs);

  return true;
}

bool Builtin::Context::performsCallback(unsigned ID,
                                        SmallVectorImpl<int> &Encoding) const {
  const char *CalleePos = ::strchr(getAttributesString(ID), 'C');
  if (!CalleePos)
    return false;

  ++CalleePos;
  parseCommaSeparatedIndices(CalleePos, Encoding);

  return true;
}

bool Builtin::Context::canBeRedeclared(unsigned ID) const {
  return ID == Builtin::NotBuiltin || ID == Builtin::BI__va_start ||
         ID == Builtin::BI__builtin_assume_aligned ||
         (!hasReferenceArgsOrResult(ID) && !hasCustomTypechecking(ID)) ||
         isInStdNamespace(ID);
}

bool Builtin::evaluateRequiredTargetFeatures(
    StringRef RequiredFeatures, const llvm::StringMap<bool> &TargetFetureMap) {
  // Return true if the builtin doesn't have any required features.
  if (RequiredFeatures.empty())
    return true;
  assert(!RequiredFeatures.contains(' ') && "Space in feature list");

  TargetFeatures TF(TargetFetureMap);
  return TF.hasRequiredFeatures(RequiredFeatures);
}
