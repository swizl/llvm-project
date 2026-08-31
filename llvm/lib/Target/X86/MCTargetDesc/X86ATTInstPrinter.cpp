//===-- X86ATTInstPrinter.cpp - AT&T assembly instruction printing --------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file includes code for rendering MCInst instances as AT&T-style
// assembly.
//
//===----------------------------------------------------------------------===//

#include "X86ATTInstPrinter.h"
#include "X86BaseInfo.h"
#include "X86InstComments.h"
#include "llvm/ADT/SmallString.h"
#include "llvm/MC/MCAsmInfo.h"
#include "llvm/MC/MCExpr.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCInstrAnalysis.h"
#include "llvm/MC/MCInstrInfo.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/Format.h"
#include "llvm/Support/raw_ostream.h"
#include <cassert>
#include <cinttypes>
#include <cstdint>

using namespace llvm;

#define DEBUG_TYPE "asm-printer"

// Include the auto-generated portion of the assembly writer.
#define PRINT_ALIAS_INSTR
#include "X86GenAsmWriter.inc"

// Print an MCExpr as an operand. Similar to GCC, wrap the output in parentheses
// if it begins with '$', as '$' in an operand position indicates an immediate
// value in the AT&T syntax.
void X86ATTInstPrinter::printExprOperand(raw_ostream &OS, const MCExpr &E) {
  SmallString<128> S;
  {
    raw_svector_ostream SOS(S);
    MAI.printExpr(SOS, E);
  }
  if (S.starts_with("$"))
    OS << '(' << S << ')';
  else
    OS << S;
}

// Translate English register name to Chinese (英文寄存器名翻译为中文)
static StringRef translateRegToChinese(StringRef Reg) {
  // 64-bit general purpose (64位通用寄存器)
  if (Reg == "rax") return "累加器";
  if (Reg == "rbx") return "基址";
  if (Reg == "rcx") return "计数";
  if (Reg == "rdx") return "数据";
  if (Reg == "rsi") return "源索引";
  if (Reg == "rdi") return "目的索引";
  if (Reg == "rbp") return "基址指针";
  if (Reg == "rsp") return "栈指针";
  if (Reg == "r8")  return "扩展8";
  if (Reg == "r9")  return "扩展9";
  if (Reg == "r10") return "扩展10";
  if (Reg == "r11") return "扩展11";
  if (Reg == "r12") return "扩展12";
  if (Reg == "r13") return "扩展13";
  if (Reg == "r14") return "扩展14";
  if (Reg == "r15") return "扩展15";

  // 32-bit general purpose (32位通用寄存器)
  if (Reg == "eax") return "累加器32";
  if (Reg == "ebx") return "基址32";
  if (Reg == "ecx") return "计数32";
  if (Reg == "edx") return "数据32";
  if (Reg == "esi") return "源索引32";
  if (Reg == "edi") return "目的索引32";
  if (Reg == "ebp") return "基址指针32";
  if (Reg == "esp") return "栈指针32";
  if (Reg == "r8d") return "扩展8_32";
  if (Reg == "r9d") return "扩展9_32";
  if (Reg == "r10d") return "扩展10_32";
  if (Reg == "r11d") return "扩展11_32";
  if (Reg == "r12d") return "扩展12_32";
  if (Reg == "r13d") return "扩展13_32";
  if (Reg == "r14d") return "扩展14_32";
  if (Reg == "r15d") return "扩展15_32";

  // 16-bit general purpose (16位通用寄存器)
  if (Reg == "ax")  return "累加器16";
  if (Reg == "bx")  return "基址16";
  if (Reg == "cx")  return "计数16";
  if (Reg == "dx")  return "数据16";
  if (Reg == "si")  return "源索引16";
  if (Reg == "di")  return "目的索引16";
  if (Reg == "bp")  return "基址指针16";
  if (Reg == "sp")  return "栈指针16";
  if (Reg == "r8w") return "扩展8_16";
  if (Reg == "r9w") return "扩展9_16";
  if (Reg == "r10w") return "扩展10_16";
  if (Reg == "r11w") return "扩展11_16";
  if (Reg == "r12w") return "扩展12_16";
  if (Reg == "r13w") return "扩展13_16";
  if (Reg == "r14w") return "扩展14_16";
  if (Reg == "r15w") return "扩展15_16";

  // 8-bit general purpose (8位通用寄存器)
  if (Reg == "al")  return "累加器8";
  if (Reg == "bl")  return "基址8";
  if (Reg == "cl")  return "计数8";
  if (Reg == "dl")  return "数据8";
  if (Reg == "sil") return "源索引8";
  if (Reg == "dil") return "目的索引8";
  if (Reg == "bpl") return "基址指针8";
  if (Reg == "spl") return "栈指针8";
  if (Reg == "r8b") return "扩展8_8";
  if (Reg == "r9b") return "扩展9_8";
  if (Reg == "r10b") return "扩展10_8";
  if (Reg == "r11b") return "扩展11_8";
  if (Reg == "r12b") return "扩展12_8";
  if (Reg == "r13b") return "扩展13_8";
  if (Reg == "r14b") return "扩展14_8";
  if (Reg == "r15b") return "扩展15_8";

  // High 8-bit registers (高8位寄存器)
  if (Reg == "ah") return "累加器高";
  if (Reg == "bh") return "基址高";
  if (Reg == "ch") return "计数高";
  if (Reg == "dh") return "数据高";

  // Instruction pointer (指令指针)
  if (Reg == "rip") return "指令指针";
  if (Reg == "eip") return "指令指针32";
  if (Reg == "ip")  return "指令指针16";

  // FLAGS register (标志寄存器)
  if (Reg == "rflags") return "标志";
  if (Reg == "eflags") return "标志32";
  if (Reg == "flags")  return "标志16";

  // Segment registers (段寄存器)
  if (Reg == "cs") return "代码段";
  if (Reg == "ds") return "数据段";
  if (Reg == "es") return "附加段";
  if (Reg == "ss") return "栈段";
  if (Reg == "fs") return "F段";
  if (Reg == "gs") return "G段";

  // XMM/YMM/ZMM registers (SIMD寄存器)
  if (Reg.starts_with("xmm")) {
    static std::string Buf;
    Buf = "浮点" + Reg.drop_front(3).str();
    return Buf;
  }
  if (Reg.starts_with("ymm")) {
    static std::string Buf;
    Buf = "浮点宽" + Reg.drop_front(3).str();
    return Buf;
  }
  if (Reg.starts_with("zmm")) {
    static std::string Buf;
    Buf = "浮点超宽" + Reg.drop_front(3).str();
    return Buf;
  }

  // Mask registers (掩码寄存器)
  if (Reg.starts_with("k")) {
    static std::string Buf;
    Buf = "掩码" + Reg.drop_front(1).str();
    return Buf;
  }

  // x87 FPU stack (x87浮点栈)
  if (Reg.starts_with("st")) return Reg;

  // Control/Debug registers (控制/调试寄存器)
  if (Reg.starts_with("cr")) {
    static std::string Buf;
    Buf = "控制" + Reg.drop_front(2).str();
    return Buf;
  }
  if (Reg.starts_with("dr")) {
    static std::string Buf;
    Buf = "调试" + Reg.drop_front(2).str();
    return Buf;
  }

  return Reg;
}

void X86ATTInstPrinter::printRegName(raw_ostream &OS, MCRegister Reg) {
  StringRef RegName = getRegisterName(Reg);
  StringRef ChineseReg = translateRegToChinese(RegName);
  markup(OS, Markup::Register) << '%' << ChineseReg;
}

// Translate English x86 mnemonic to Chinese at print time
static StringRef translateMnemonicToChinese(StringRef Mnemonic) {
  // Data movement
  if (Mnemonic == "mov")     return "移动";
  if (Mnemonic == "movb")    return "移动b";
  if (Mnemonic == "movw")    return "移动w";
  if (Mnemonic == "movl")    return "移动l";
  if (Mnemonic == "movq")    return "移动q";
  if (Mnemonic == "movabs")  return "移动绝对";
  if (Mnemonic == "movzx")   return "移动零扩展";
  if (Mnemonic == "movsx")   return "移动符号扩展";
  if (Mnemonic == "movsxd")  return "移动符号扩展d";
  if (Mnemonic == "lea")     return "加载有效地址";
  if (Mnemonic == "leaq")    return "加载有效地址q";
  if (Mnemonic == "leal")    return "加载有效地址l";
  if (Mnemonic == "xchg")    return "交换";
  if (Mnemonic == "push")    return "压栈";
  if (Mnemonic == "pushq")   return "压栈q";
  if (Mnemonic == "pop")     return "出栈";
  if (Mnemonic == "popq")    return "出栈q";
  if (Mnemonic == "cltq")    return "符号扩展";
  if (Mnemonic == "cdq")     return "零扩展";
  if (Mnemonic == "cqo")     return "零扩展";

  // Arithmetic
  if (Mnemonic == "add")     return "加";
  if (Mnemonic == "addb")    return "加b";
  if (Mnemonic == "addw")    return "加w";
  if (Mnemonic == "addl")    return "加l";
  if (Mnemonic == "addq")    return "加q";
  if (Mnemonic == "sub")     return "减";
  if (Mnemonic == "subl")    return "减l";
  if (Mnemonic == "subq")    return "减q";
  if (Mnemonic == "imul")    return "乘";
  if (Mnemonic == "imull")   return "乘l";
  if (Mnemonic == "imulq")   return "乘q";
  if (Mnemonic == "idiv")    return "除";
  if (Mnemonic == "div")     return "无符号除";
  if (Mnemonic == "neg")     return "取反";
  if (Mnemonic == "negl")    return "取反l";
  if (Mnemonic == "negq")    return "取反q";
  if (Mnemonic == "inc")     return "自增";
  if (Mnemonic == "incl")    return "自增l";
  if (Mnemonic == "incq")    return "自增q";
  if (Mnemonic == "dec")     return "自减";
  if (Mnemonic == "decl")    return "自减l";
  if (Mnemonic == "decq")    return "自减q";
  if (Mnemonic == "cmp")     return "比较";
  if (Mnemonic == "cmpl")    return "比较l";
  if (Mnemonic == "cmpq")    return "比较q";

  // Logic
  if (Mnemonic == "and")     return "与";
  if (Mnemonic == "andl")    return "与l";
  if (Mnemonic == "andq")    return "与q";
  if (Mnemonic == "or")      return "或";
  if (Mnemonic == "orl")     return "或l";
  if (Mnemonic == "orq")     return "或q";
  if (Mnemonic == "xor")     return "异或";
  if (Mnemonic == "xorl")    return "异或l";
  if (Mnemonic == "xorq")    return "异或q";
  if (Mnemonic == "not")     return "取反非";
  if (Mnemonic == "test")    return "测试";
  if (Mnemonic == "testb")   return "测试b";
  if (Mnemonic == "testl")   return "测试l";
  if (Mnemonic == "testq")   return "测试q";

  // Shift
  if (Mnemonic == "shl")     return "左移";
  if (Mnemonic == "shll")    return "左移l";
  if (Mnemonic == "shlq")    return "左移q";
  if (Mnemonic == "shr")     return "逻辑右移";
  if (Mnemonic == "shrl")    return "逻辑右移l";
  if (Mnemonic == "shrq")    return "逻辑右移q";
  if (Mnemonic == "sar")     return "算术右移";
  if (Mnemonic == "sarl")    return "算术右移l";
  if (Mnemonic == "sarq")    return "算术右移q";

  // Branch
  if (Mnemonic == "jmp")     return "跳转";
  if (Mnemonic == "call")    return "调用";
  if (Mnemonic == "callq")   return "调用q";
  if (Mnemonic == "ret")     return "返回";
  if (Mnemonic == "retq")    return "返回q";
  if (Mnemonic == "je")      return "相等跳转";
  if (Mnemonic == "jne")     return "不等跳转";
  if (Mnemonic == "jl")      return "小于跳转";
  if (Mnemonic == "jg")      return "大于跳转";
  if (Mnemonic == "jle")     return "小于等于跳转";
  if (Mnemonic == "jge")     return "大于等于跳转";
  if (Mnemonic == "jb")      return "无符号小于跳转";
  if (Mnemonic == "ja")      return "无符号大于跳转";
  if (Mnemonic == "jbe")     return "无符号小于等于跳转";
  if (Mnemonic == "jae")     return "无符号大于等于跳转";
  if (Mnemonic == "jz")      return "为零跳转";
  if (Mnemonic == "jnz")     return "非零跳转";
  if (Mnemonic == "js")      return "为负跳转";
  if (Mnemonic == "jns")     return "为正跳转";

  // Conditional set
  if (Mnemonic == "sete")    return "相等设置";
  if (Mnemonic == "setne")   return "不等设置";
  if (Mnemonic == "setl")    return "小于设置";
  if (Mnemonic == "setg")    return "大于设置";
  if (Mnemonic == "setle")   return "小于等于设置";
  if (Mnemonic == "setge")   return "大于等于设置";

  // System
  if (Mnemonic == "nop")     return "空操作";
  if (Mnemonic == "hlt")     return "停机";
  if (Mnemonic == "syscall") return "系统调用";
  if (Mnemonic == "int")     return "中断";
  if (Mnemonic == "leave")   return "销毁栈帧";
  if (Mnemonic == "enter")   return "建立栈帧";
  if (Mnemonic == "clc")     return "进位清零";
  if (Mnemonic == "stc")     return "进位设置";
  if (Mnemonic == "cli")     return "中断清零";
  if (Mnemonic == "sti")     return "中断设置";
  if (Mnemonic == "cld")     return "方向清零";
  if (Mnemonic == "std")     return "方向设置";

  return Mnemonic;
}

void X86ATTInstPrinter::printInst(const MCInst *MI, uint64_t Address,
                                  StringRef Annot, const MCSubtargetInfo &STI,
                                  raw_ostream &OS) {
  // If verbose assembly is enabled, we can print some informative comments.
  if (CommentStream)
    HasCustomInstComment = EmitAnyX86InstComments(MI, *CommentStream, MII);

  printInstFlags(MI, OS, STI);

  // Output CALLpcrel32 as "callq" in 64-bit mode.
  // In Intel annotation it's always emitted as "call".
  //
  // TODO: Probably this hack should be redesigned via InstAlias in
  // InstrInfo.td as soon as Requires clause is supported properly
  // for InstAlias.
  if (MI->getOpcode() == X86::CALLpcrel32 &&
      (STI.hasFeature(X86::Is64Bit))) {
    OS << "\tcallq\t";
    printPCRelImm(MI, Address, 0, OS);
  }
  // data16 and data32 both have the same encoding of 0x66. While data32 is
  // valid only in 16 bit systems, data16 is valid in the rest.
  // There seems to be some lack of support of the Requires clause that causes
  // 0x66 to be interpreted as "data16" by the asm printer.
  // Thus we add an adjustment here in order to print the "right" instruction.
  else if (MI->getOpcode() == X86::DATA16_PREFIX &&
           STI.hasFeature(X86::Is16Bit)) {
    OS << "\tdata32";
  }
  // Try to print any aliases first.
  else if (!printAliasInstr(MI, Address, OS) && !printVecCompareInstr(MI, OS)) {
    // Capture output, translate mnemonic to Chinese, then write
    std::string Buf;
    raw_string_ostream TmpOS(Buf);
    printInstruction(MI, Address, TmpOS);
    TmpOS.flush();
    // The output format is "\tmnemonic\toperands" or "\tmnemonic"
    // Translate the mnemonic part
    if (!Buf.empty() && Buf[0] == '\t') {
      size_t TabPos = Buf.find('\t', 1);
      if (TabPos != std::string::npos) {
        StringRef Mnemonic(Buf.data() + 1, TabPos - 1);
        StringRef Translated = translateMnemonicToChinese(Mnemonic);
        OS << '\t' << Translated << Buf.substr(TabPos);
      } else {
        StringRef Mnemonic(Buf.data() + 1, Buf.size() - 1);
        StringRef Translated = translateMnemonicToChinese(Mnemonic);
        OS << '\t' << Translated;
      }
    } else {
      OS << Buf;
    }
  }

  // Next always print the annotation.
  printAnnotation(OS, Annot);
}

bool X86ATTInstPrinter::printVecCompareInstr(const MCInst *MI,
                                             raw_ostream &OS) {
  if (MI->getNumOperands() == 0 ||
      !MI->getOperand(MI->getNumOperands() - 1).isImm())
    return false;

  int64_t Imm = MI->getOperand(MI->getNumOperands() - 1).getImm();

  const MCInstrDesc &Desc = MII.get(MI->getOpcode());

  // Custom print the vector compare instructions to get the immediate
  // translated into the mnemonic.
  switch (MI->getOpcode()) {
  case X86::CMPPDrmi:     case X86::CMPPDrri:
  case X86::CMPPSrmi:     case X86::CMPPSrri:
  case X86::CMPSDrmi:     case X86::CMPSDrri:
  case X86::CMPSDrmi_Int: case X86::CMPSDrri_Int:
  case X86::CMPSSrmi:     case X86::CMPSSrri:
  case X86::CMPSSrmi_Int: case X86::CMPSSrri_Int:
    if (Imm >= 0 && Imm <= 7) {
      OS << '\t';
      printCMPMnemonic(MI, /*IsVCMP*/false, OS);

      if ((Desc.TSFlags & X86II::FormMask) == X86II::MRMSrcMem) {
        if ((Desc.TSFlags & X86II::OpPrefixMask) == X86II::XS)
          printdwordmem(MI, 2, OS);
        else if ((Desc.TSFlags & X86II::OpPrefixMask) == X86II::XD)
          printqwordmem(MI, 2, OS);
        else
          printxmmwordmem(MI, 2, OS);
      } else
        printOperand(MI, 2, OS);

      // Skip operand 1 as its tied to the dest.

      OS << ", ";
      printOperand(MI, 0, OS);
      return true;
    }
    break;

  case X86::VCMPPDrmi:       case X86::VCMPPDrri:
  case X86::VCMPPDYrmi:      case X86::VCMPPDYrri:
  case X86::VCMPPDZ128rmi:   case X86::VCMPPDZ128rri:
  case X86::VCMPPDZ256rmi:   case X86::VCMPPDZ256rri:
  case X86::VCMPPDZrmi:      case X86::VCMPPDZrri:
  case X86::VCMPPSrmi:       case X86::VCMPPSrri:
  case X86::VCMPPSYrmi:      case X86::VCMPPSYrri:
  case X86::VCMPPSZ128rmi:   case X86::VCMPPSZ128rri:
  case X86::VCMPPSZ256rmi:   case X86::VCMPPSZ256rri:
  case X86::VCMPPSZrmi:      case X86::VCMPPSZrri:
  case X86::VCMPSDrmi:       case X86::VCMPSDrri:
  case X86::VCMPSDZrmi:      case X86::VCMPSDZrri:
  case X86::VCMPSDrmi_Int:   case X86::VCMPSDrri_Int:
  case X86::VCMPSDZrmi_Int:  case X86::VCMPSDZrri_Int:
  case X86::VCMPSSrmi:       case X86::VCMPSSrri:
  case X86::VCMPSSZrmi:      case X86::VCMPSSZrri:
  case X86::VCMPSSrmi_Int:   case X86::VCMPSSrri_Int:
  case X86::VCMPSSZrmi_Int:  case X86::VCMPSSZrri_Int:
  case X86::VCMPPDZ128rmik:  case X86::VCMPPDZ128rrik:
  case X86::VCMPPDZ256rmik:  case X86::VCMPPDZ256rrik:
  case X86::VCMPPDZrmik:     case X86::VCMPPDZrrik:
  case X86::VCMPPSZ128rmik:  case X86::VCMPPSZ128rrik:
  case X86::VCMPPSZ256rmik:  case X86::VCMPPSZ256rrik:
  case X86::VCMPPSZrmik:     case X86::VCMPPSZrrik:
  case X86::VCMPSDZrmik_Int: case X86::VCMPSDZrrik_Int:
  case X86::VCMPSSZrmik_Int: case X86::VCMPSSZrrik_Int:
  case X86::VCMPPDZ128rmbi:  case X86::VCMPPDZ128rmbik:
  case X86::VCMPPDZ256rmbi:  case X86::VCMPPDZ256rmbik:
  case X86::VCMPPDZrmbi:     case X86::VCMPPDZrmbik:
  case X86::VCMPPSZ128rmbi:  case X86::VCMPPSZ128rmbik:
  case X86::VCMPPSZ256rmbi:  case X86::VCMPPSZ256rmbik:
  case X86::VCMPPSZrmbi:     case X86::VCMPPSZrmbik:
  case X86::VCMPPDZrrib:     case X86::VCMPPDZrribk:
  case X86::VCMPPSZrrib:     case X86::VCMPPSZrribk:
  case X86::VCMPSDZrrib_Int: case X86::VCMPSDZrribk_Int:
  case X86::VCMPSSZrrib_Int: case X86::VCMPSSZrribk_Int:
  case X86::VCMPPHZ128rmi:   case X86::VCMPPHZ128rri:
  case X86::VCMPPHZ256rmi:   case X86::VCMPPHZ256rri:
  case X86::VCMPPHZrmi:      case X86::VCMPPHZrri:
  case X86::VCMPSHZrmi:      case X86::VCMPSHZrri:
  case X86::VCMPSHZrmi_Int:  case X86::VCMPSHZrri_Int:
  case X86::VCMPPHZ128rmik:  case X86::VCMPPHZ128rrik:
  case X86::VCMPPHZ256rmik:  case X86::VCMPPHZ256rrik:
  case X86::VCMPPHZrmik:     case X86::VCMPPHZrrik:
  case X86::VCMPSHZrmik_Int: case X86::VCMPSHZrrik_Int:
  case X86::VCMPPHZ128rmbi:  case X86::VCMPPHZ128rmbik:
  case X86::VCMPPHZ256rmbi:  case X86::VCMPPHZ256rmbik:
  case X86::VCMPPHZrmbi:     case X86::VCMPPHZrmbik:
  case X86::VCMPPHZrrib:     case X86::VCMPPHZrribk:
  case X86::VCMPSHZrrib_Int: case X86::VCMPSHZrribk_Int:
  case X86::VCMPBF16Z128rmi:  case X86::VCMPBF16Z128rri:
  case X86::VCMPBF16Z256rmi:  case X86::VCMPBF16Z256rri:
  case X86::VCMPBF16Zrmi:     case X86::VCMPBF16Zrri:
  case X86::VCMPBF16Z128rmik: case X86::VCMPBF16Z128rrik:
  case X86::VCMPBF16Z256rmik: case X86::VCMPBF16Z256rrik:
  case X86::VCMPBF16Zrmik:    case X86::VCMPBF16Zrrik:
  case X86::VCMPBF16Z128rmbi: case X86::VCMPBF16Z128rmbik:
  case X86::VCMPBF16Z256rmbi: case X86::VCMPBF16Z256rmbik:
  case X86::VCMPBF16Zrmbi:    case X86::VCMPBF16Zrmbik:
    if (Imm >= 0 && Imm <= 31) {
      OS << '\t';
      printCMPMnemonic(MI, /*IsVCMP*/true, OS);

      unsigned CurOp = (Desc.TSFlags & X86II::EVEX_K) ? 3 : 2;

      if ((Desc.TSFlags & X86II::FormMask) == X86II::MRMSrcMem) {
        if (Desc.TSFlags & X86II::EVEX_B) {
          // Broadcast form.
          // Load size is word for TA map. Otherwise it is based on W-bit.
          if ((Desc.TSFlags & X86II::OpMapMask) == X86II::TA) {
            assert(!(Desc.TSFlags & X86II::REX_W) && "Unknown W-bit value!");
            printwordmem(MI, CurOp--, OS);
          } else if (Desc.TSFlags & X86II::REX_W) {
            printqwordmem(MI, CurOp--, OS);
          } else {
            printdwordmem(MI, CurOp--, OS);
          }

          // Print the number of elements broadcasted.
          unsigned NumElts;
          if (Desc.TSFlags & X86II::EVEX_L2)
            NumElts = (Desc.TSFlags & X86II::REX_W) ? 8 : 16;
          else if (Desc.TSFlags & X86II::VEX_L)
            NumElts = (Desc.TSFlags & X86II::REX_W) ? 4 : 8;
          else
            NumElts = (Desc.TSFlags & X86II::REX_W) ? 2 : 4;
          if ((Desc.TSFlags & X86II::OpMapMask) == X86II::TA) {
            assert(!(Desc.TSFlags & X86II::REX_W) && "Unknown W-bit value!");
            NumElts *= 2;
          }
          OS << "{1to" << NumElts << "}";
        } else {
          if ((Desc.TSFlags & X86II::OpPrefixMask) == X86II::XS) {
            if ((Desc.TSFlags & X86II::OpMapMask) == X86II::TA)
              printwordmem(MI, CurOp--, OS);
            else
              printdwordmem(MI, CurOp--, OS);
          } else if ((Desc.TSFlags & X86II::OpPrefixMask) == X86II::XD &&
                     (Desc.TSFlags & X86II::OpMapMask) != X86II::TA) {
            printqwordmem(MI, CurOp--, OS);
          } else if (Desc.TSFlags & X86II::EVEX_L2) {
            printzmmwordmem(MI, CurOp--, OS);
          } else if (Desc.TSFlags & X86II::VEX_L) {
            printymmwordmem(MI, CurOp--, OS);
          } else {
            printxmmwordmem(MI, CurOp--, OS);
          }
        }
      } else {
        if (Desc.TSFlags & X86II::EVEX_B)
          OS << "{sae}, ";
        printOperand(MI, CurOp--, OS);
      }

      OS << ", ";
      printOperand(MI, CurOp--, OS);
      OS << ", ";
      printOperand(MI, 0, OS);
      if (CurOp > 0) {
        // Print mask operand.
        OS << " {";
        printOperand(MI, CurOp--, OS);
        OS << "}";
      }

      return true;
    }
    break;

  case X86::VPCOMBmi:  case X86::VPCOMBri:
  case X86::VPCOMDmi:  case X86::VPCOMDri:
  case X86::VPCOMQmi:  case X86::VPCOMQri:
  case X86::VPCOMUBmi: case X86::VPCOMUBri:
  case X86::VPCOMUDmi: case X86::VPCOMUDri:
  case X86::VPCOMUQmi: case X86::VPCOMUQri:
  case X86::VPCOMUWmi: case X86::VPCOMUWri:
  case X86::VPCOMWmi:  case X86::VPCOMWri:
    if (Imm >= 0 && Imm <= 7) {
      OS << '\t';
      printVPCOMMnemonic(MI, OS);

      if ((Desc.TSFlags & X86II::FormMask) == X86II::MRMSrcMem)
        printxmmwordmem(MI, 2, OS);
      else
        printOperand(MI, 2, OS);

      OS << ", ";
      printOperand(MI, 1, OS);
      OS << ", ";
      printOperand(MI, 0, OS);
      return true;
    }
    break;

  case X86::VPCMPBZ128rmi:   case X86::VPCMPBZ128rri:
  case X86::VPCMPBZ256rmi:   case X86::VPCMPBZ256rri:
  case X86::VPCMPBZrmi:      case X86::VPCMPBZrri:
  case X86::VPCMPDZ128rmi:   case X86::VPCMPDZ128rri:
  case X86::VPCMPDZ256rmi:   case X86::VPCMPDZ256rri:
  case X86::VPCMPDZrmi:      case X86::VPCMPDZrri:
  case X86::VPCMPQZ128rmi:   case X86::VPCMPQZ128rri:
  case X86::VPCMPQZ256rmi:   case X86::VPCMPQZ256rri:
  case X86::VPCMPQZrmi:      case X86::VPCMPQZrri:
  case X86::VPCMPUBZ128rmi:  case X86::VPCMPUBZ128rri:
  case X86::VPCMPUBZ256rmi:  case X86::VPCMPUBZ256rri:
  case X86::VPCMPUBZrmi:     case X86::VPCMPUBZrri:
  case X86::VPCMPUDZ128rmi:  case X86::VPCMPUDZ128rri:
  case X86::VPCMPUDZ256rmi:  case X86::VPCMPUDZ256rri:
  case X86::VPCMPUDZrmi:     case X86::VPCMPUDZrri:
  case X86::VPCMPUQZ128rmi:  case X86::VPCMPUQZ128rri:
  case X86::VPCMPUQZ256rmi:  case X86::VPCMPUQZ256rri:
  case X86::VPCMPUQZrmi:     case X86::VPCMPUQZrri:
  case X86::VPCMPUWZ128rmi:  case X86::VPCMPUWZ128rri:
  case X86::VPCMPUWZ256rmi:  case X86::VPCMPUWZ256rri:
  case X86::VPCMPUWZrmi:     case X86::VPCMPUWZrri:
  case X86::VPCMPWZ128rmi:   case X86::VPCMPWZ128rri:
  case X86::VPCMPWZ256rmi:   case X86::VPCMPWZ256rri:
  case X86::VPCMPWZrmi:      case X86::VPCMPWZrri:
  case X86::VPCMPBZ128rmik:  case X86::VPCMPBZ128rrik:
  case X86::VPCMPBZ256rmik:  case X86::VPCMPBZ256rrik:
  case X86::VPCMPBZrmik:     case X86::VPCMPBZrrik:
  case X86::VPCMPDZ128rmik:  case X86::VPCMPDZ128rrik:
  case X86::VPCMPDZ256rmik:  case X86::VPCMPDZ256rrik:
  case X86::VPCMPDZrmik:     case X86::VPCMPDZrrik:
  case X86::VPCMPQZ128rmik:  case X86::VPCMPQZ128rrik:
  case X86::VPCMPQZ256rmik:  case X86::VPCMPQZ256rrik:
  case X86::VPCMPQZrmik:     case X86::VPCMPQZrrik:
  case X86::VPCMPUBZ128rmik: case X86::VPCMPUBZ128rrik:
  case X86::VPCMPUBZ256rmik: case X86::VPCMPUBZ256rrik:
  case X86::VPCMPUBZrmik:    case X86::VPCMPUBZrrik:
  case X86::VPCMPUDZ128rmik: case X86::VPCMPUDZ128rrik:
  case X86::VPCMPUDZ256rmik: case X86::VPCMPUDZ256rrik:
  case X86::VPCMPUDZrmik:    case X86::VPCMPUDZrrik:
  case X86::VPCMPUQZ128rmik: case X86::VPCMPUQZ128rrik:
  case X86::VPCMPUQZ256rmik: case X86::VPCMPUQZ256rrik:
  case X86::VPCMPUQZrmik:    case X86::VPCMPUQZrrik:
  case X86::VPCMPUWZ128rmik: case X86::VPCMPUWZ128rrik:
  case X86::VPCMPUWZ256rmik: case X86::VPCMPUWZ256rrik:
  case X86::VPCMPUWZrmik:    case X86::VPCMPUWZrrik:
  case X86::VPCMPWZ128rmik:  case X86::VPCMPWZ128rrik:
  case X86::VPCMPWZ256rmik:  case X86::VPCMPWZ256rrik:
  case X86::VPCMPWZrmik:     case X86::VPCMPWZrrik:
  case X86::VPCMPDZ128rmbi:  case X86::VPCMPDZ128rmbik:
  case X86::VPCMPDZ256rmbi:  case X86::VPCMPDZ256rmbik:
  case X86::VPCMPDZrmbi:     case X86::VPCMPDZrmbik:
  case X86::VPCMPQZ128rmbi:  case X86::VPCMPQZ128rmbik:
  case X86::VPCMPQZ256rmbi:  case X86::VPCMPQZ256rmbik:
  case X86::VPCMPQZrmbi:     case X86::VPCMPQZrmbik:
  case X86::VPCMPUDZ128rmbi: case X86::VPCMPUDZ128rmbik:
  case X86::VPCMPUDZ256rmbi: case X86::VPCMPUDZ256rmbik:
  case X86::VPCMPUDZrmbi:    case X86::VPCMPUDZrmbik:
  case X86::VPCMPUQZ128rmbi: case X86::VPCMPUQZ128rmbik:
  case X86::VPCMPUQZ256rmbi: case X86::VPCMPUQZ256rmbik:
  case X86::VPCMPUQZrmbi:    case X86::VPCMPUQZrmbik:
    if ((Imm >= 0 && Imm <= 2) || (Imm >= 4 && Imm <= 6)) {
      OS << '\t';
      printVPCMPMnemonic(MI, OS);

      unsigned CurOp = (Desc.TSFlags & X86II::EVEX_K) ? 3 : 2;

      if ((Desc.TSFlags & X86II::FormMask) == X86II::MRMSrcMem) {
        if (Desc.TSFlags & X86II::EVEX_B) {
          // Broadcast form.
          // Load size is based on W-bit as only D and Q are supported.
          if (Desc.TSFlags & X86II::REX_W)
            printqwordmem(MI, CurOp--, OS);
          else
            printdwordmem(MI, CurOp--, OS);

          // Print the number of elements broadcasted.
          unsigned NumElts;
          if (Desc.TSFlags & X86II::EVEX_L2)
            NumElts = (Desc.TSFlags & X86II::REX_W) ? 8 : 16;
          else if (Desc.TSFlags & X86II::VEX_L)
            NumElts = (Desc.TSFlags & X86II::REX_W) ? 4 : 8;
          else
            NumElts = (Desc.TSFlags & X86II::REX_W) ? 2 : 4;
          OS << "{1to" << NumElts << "}";
        } else {
          if (Desc.TSFlags & X86II::EVEX_L2)
            printzmmwordmem(MI, CurOp--, OS);
          else if (Desc.TSFlags & X86II::VEX_L)
            printymmwordmem(MI, CurOp--, OS);
          else
            printxmmwordmem(MI, CurOp--, OS);
        }
      } else {
        printOperand(MI, CurOp--, OS);
      }

      OS << ", ";
      printOperand(MI, CurOp--, OS);
      OS << ", ";
      printOperand(MI, 0, OS);
      if (CurOp > 0) {
        // Print mask operand.
        OS << " {";
        printOperand(MI, CurOp--, OS);
        OS << "}";
      }

      return true;
    }
    break;
  }

  return false;
}

void X86ATTInstPrinter::printOperand(const MCInst *MI, unsigned OpNo,
                                     raw_ostream &O) {
  const MCOperand &Op = MI->getOperand(OpNo);
  if (Op.isReg()) {
    printRegName(O, Op.getReg());
  } else if (Op.isImm()) {
    // Print immediates as signed values.
    int64_t Imm = Op.getImm();
    markup(O, Markup::Immediate) << '$' << formatImm(Imm);

    // TODO: This should be in a helper function in the base class, so it can
    // be used by other printers.

    // If there are no instruction-specific comments, add a comment clarifying
    // the hex value of the immediate operand when it isn't in the range
    // [-256,255].
    if (CommentStream && !HasCustomInstComment && (Imm > 255 || Imm < -256)) {
      // Don't print unnecessary hex sign bits.
      if (Imm == (int16_t)(Imm))
        *CommentStream << format("imm = 0x%" PRIX16 "\n", (uint16_t)Imm);
      else if (Imm == (int32_t)(Imm))
        *CommentStream << format("imm = 0x%" PRIX32 "\n", (uint32_t)Imm);
      else
        *CommentStream << format("imm = 0x%" PRIX64 "\n", (uint64_t)Imm);
    }
  } else {
    assert(Op.isExpr() && "unknown operand kind in printOperand");
    WithMarkup M = markup(O, Markup::Immediate);
    O << '$';
    MAI.printExpr(O, *Op.getExpr());
  }
}

void X86ATTInstPrinter::printMemReference(const MCInst *MI, unsigned Op,
                                          raw_ostream &O) {
  // Do not print the exact form of the memory operand if it references a known
  // binary object.
  if (SymbolizeOperands && MIA) {
    uint64_t Target;
    if (MIA->evaluateBranch(*MI, 0, 0, Target))
      return;
    if (MIA->evaluateMemoryOperandAddress(*MI, /*STI=*/nullptr, 0, 0))
      return;
  }

  const MCOperand &BaseReg = MI->getOperand(Op + X86::AddrBaseReg);
  const MCOperand &IndexReg = MI->getOperand(Op + X86::AddrIndexReg);
  const MCOperand &DispSpec = MI->getOperand(Op + X86::AddrDisp);

  WithMarkup M = markup(O, Markup::Memory);

  // If this has a segment register, print it.
  printOptionalSegReg(MI, Op + X86::AddrSegmentReg, O);

  if (DispSpec.isImm()) {
    int64_t DispVal = DispSpec.getImm();
    if (DispVal || (!IndexReg.getReg() && !BaseReg.getReg()))
      O << formatImm(DispVal);
  } else {
    assert(DispSpec.isExpr() && "non-immediate displacement for LEA?");
    printExprOperand(O, *DispSpec.getExpr());
  }

  if (IndexReg.getReg() || BaseReg.getReg()) {
    O << '(';
    if (BaseReg.getReg())
      printOperand(MI, Op + X86::AddrBaseReg, O);

    if (IndexReg.getReg()) {
      O << ',';
      printOperand(MI, Op + X86::AddrIndexReg, O);
      unsigned ScaleVal = MI->getOperand(Op + X86::AddrScaleAmt).getImm();
      if (ScaleVal != 1) {
        O << ',';
        markup(O, Markup::Immediate) << ScaleVal; // never printed in hex.
      }
    }
    O << ')';
  }
}

void X86ATTInstPrinter::printSrcIdx(const MCInst *MI, unsigned Op,
                                    raw_ostream &O) {
  WithMarkup M = markup(O, Markup::Memory);

  // If this has a segment register, print it.
  printOptionalSegReg(MI, Op + 1, O);

  O << "(";
  printOperand(MI, Op, O);
  O << ")";
}

void X86ATTInstPrinter::printDstIdx(const MCInst *MI, unsigned Op,
                                    raw_ostream &O) {
  WithMarkup M = markup(O, Markup::Memory);

  O << "%es:(";
  printOperand(MI, Op, O);
  O << ")";
}

void X86ATTInstPrinter::printMemOffset(const MCInst *MI, unsigned Op,
                                       raw_ostream &O) {
  const MCOperand &DispSpec = MI->getOperand(Op);

  WithMarkup M = markup(O, Markup::Memory);

  // If this has a segment register, print it.
  printOptionalSegReg(MI, Op + 1, O);

  if (DispSpec.isImm()) {
    O << formatImm(DispSpec.getImm());
  } else {
    assert(DispSpec.isExpr() && "non-immediate displacement?");
    printExprOperand(O, *DispSpec.getExpr());
  }
}

void X86ATTInstPrinter::printU8Imm(const MCInst *MI, unsigned Op,
                                   raw_ostream &O) {
  if (MI->getOperand(Op).isExpr())
    return printOperand(MI, Op, O);

  markup(O, Markup::Immediate)
      << '$' << formatImm(MI->getOperand(Op).getImm() & 0xff);
}

void X86ATTInstPrinter::printSTiRegOperand(const MCInst *MI, unsigned OpNo,
                                           raw_ostream &OS) {
  MCRegister Reg = MI->getOperand(OpNo).getReg();
  // Override the default printing to print st(0) instead st.
  if (Reg == X86::ST0)
    markup(OS, Markup::Register) << "%st(0)";
  else
    printRegName(OS, Reg);
}
