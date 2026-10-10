; PR1117
; RUN: not llvm-as -disable-output %s 2>&1 | FileCheck %s

; CHECK: error: invalid cast opcode for cast from '整数64' to '指针'
@X = constant ptr trunc (i64 0 to ptr)
