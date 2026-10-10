; RUN: llvm-as < %s | llvm-dis | llvm-as | llvm-dis | FileCheck %s

; Test that align(N) is accepted as an alternative syntax to align N

; CHECK: 定义 空类型 @param_align4(指针 align 4 %ptr) {
define void @param_align4(ptr align(4) %ptr) {
  ret void
}

; CHECK: 定义 空类型 @param_align128(指针 align 128 %0) {
define void @param_align128(ptr align(128)) {
  ret void
}
