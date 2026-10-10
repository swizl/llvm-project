; RUN: llvm-as < %s | llvm-dis | FileCheck %s
; RUN: verify-uselistorder %s

; Make sure no arguments is accepted
; CHECK: 定义 x86_intrcc 空类型 @no_args() {
define x86_intrcc void @no_args() {
  ret void
}

; CHECK: 定义 x86_intrcc 空类型 @byval_arg(指针 byval(整数32) %0) {
define x86_intrcc void @byval_arg(ptr byval(i32)) {
  ret void
}
