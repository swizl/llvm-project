; RUN: llvm-as < %s | llvm-dis -show-annotations | FileCheck -check-prefix=ANNOT %s
; RUN: llvm-as < %s | llvm-dis | FileCheck -check-prefix=BARE %s
; RUN: verify-uselistorder %s

; The bare version of this file should not have any #uses lines.
; BARE: @B =
; BARE-NOT: #uses
; BARE: }

@B = external global i32
; ANNOT: @B = 外部 全局 整数32   ; [#uses=0 type=指针]

define <4 x i1> @foo(<4 x float> %a, <4 x float> %b) nounwind {
entry:
  %cmp = fcmp olt <4 x float> %a, %b              ; [#uses=1]
  ret <4 x i1> %cmp
}

; ANNOT: %cmp = 浮点比较 olt <4 个 单精度> %a, %b              ; [#uses=1 type=<4 个 整数1>]

