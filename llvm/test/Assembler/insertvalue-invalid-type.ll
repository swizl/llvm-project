; RUN: not llvm-as < %s 2>&1 | FileCheck %s

; CHECK: insertvalue operand and field disagree in type: '指针' instead of '整数32'

define void @test() {
entry:
  insertvalue { i32, i32 } undef, ptr null, 0
  ret void
}
