; RUN: llvm-as < %s | llvm-dis | llvm-as | llvm-dis | FileCheck %s
; RUN: verify-uselistorder %s

define void @foo() {
entry:
; CHECK: %alloc32 = 分配 整数1, 对齐 8
; CHECK: %alloc64 = 分配 整数1, 整数64 1, 对齐 8
  %alloc32 = alloca i1, i32 1, align 8
  %alloc64 = alloca i1, i64 1, align 8
  unreachable
}
