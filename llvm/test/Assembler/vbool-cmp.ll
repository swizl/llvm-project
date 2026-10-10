; RUN: llvm-as < %s | llvm-dis | llvm-as | llvm-dis | FileCheck %s
; RUN: verify-uselistorder %s
; Rudimentary test of fcmp/icmp on vectors returning vector of bool

; CHECK: @ffoo
; CHECK: 浮点比较 olt <4 个 单精度> %a, %b
define <4 x i1> @ffoo(<4 x float> %a, <4 x float> %b) nounwind {
entry:
  %cmp = fcmp olt <4 x float> %a, %b		; <4 x i1> [#uses=1]
  ret <4 x i1> %cmp
}

; CHECK: @ifoo
; CHECK: 整数比较 slt <4 个 整数32> %a, %b
define <4 x i1> @ifoo(<4 x i32> %a, <4 x i32> %b) nounwind {
entry:
  %cmp = icmp slt <4 x i32> %a, %b		; <4 x i1> [#uses=1]
  ret <4 x i1> %cmp
}
