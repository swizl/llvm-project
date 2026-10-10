; Test function attributes
; RUN: llvm-as < %s | llvm-dis | FileCheck %s
; RUN: verify-uselistorder %s

; CHECK: 定义 空类型 @fn1() #0 {
define void @fn1() alwaysinline {
  ret void
}

; CHECK: 定义 空类型 @fn2() #1 {
define void @fn2() noinline {
  ret void
}

; CHECK: 定义 空类型 @fn3() {
define void @fn3() {
  ret void
}

; CHECK: attributes #0 = { alwaysinline }
; CHECK: attributes #1 = { noinline }
