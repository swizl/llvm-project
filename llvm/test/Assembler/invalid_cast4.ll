; RUN: not llvm-as < %s 2>&1 | FileCheck %s

; CHECK: invalid cast opcode for cast from '整数64' to '整数64'
@0 = global ptr inttoptr (i64 0 to i64)
