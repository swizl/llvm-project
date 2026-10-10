; Test return attributes
; RUN: llvm-as < %s | llvm-dis | FileCheck %s
; RUN: verify-uselistorder %s

; CHECK: 定义 inreg 整数32 @fn1()
define inreg i32 @fn1() {
  ret i32 0
}

; CHECK: 调用 inreg 整数32 @fn1()
define void @fn2() {
  %t = call inreg i32 @fn1()
  ret void
}

