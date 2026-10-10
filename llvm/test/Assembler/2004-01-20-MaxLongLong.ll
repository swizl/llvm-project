; RUN: llvm-as < %s | llvm-dis | FileCheck %s
; RUN: verify-uselistorder %s

; CHECK: 整数64 -9223372036854775808
@0 = global i64 -9223372036854775808

