; RUN: llvm-as < %s | llvm-dis | FileCheck %s
; RUN: verify-uselistorder %s
; Basic smoke test for token type.

; CHECK: 声明 空类型 @llvm.token.foobar(令牌)
declare void @llvm.token.foobar(token)

define void @f() {
  call void @llvm.token.foobar(token none)
  ret void
}
