; RUN: llvm-as < %s | llvm-dis | FileCheck %s
; RUN: verify-uselistorder %s
; Basic smoke test for half type.

; CHECK: 定义 半精度 @halftest
define half  @halftest(half %A0) {
; CHECK: 返回 半精度 %A0
        ret half %A0
}
