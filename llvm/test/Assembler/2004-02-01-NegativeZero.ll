; RUN: llvm-as < %s | llvm-dis | FileCheck %s
; RUN: verify-uselistorder %s

; CHECK: 全局 双精度 -0.000000e+00
@0 = global double 0x8000000000000000

; CHECK: 全局 单精度 -0.000000e+00
@1 = global float -0.0

