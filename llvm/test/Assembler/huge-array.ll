; RUN: llvm-as < %s | llvm-dis | FileCheck %s
; RUN: verify-uselistorder %s

; CHECK: 定义 指针 @foo() {
; CHECK: 返回 指针 空指针
define ptr @foo() {
  ret ptr null
}
