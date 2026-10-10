; RUN: llvm-as < %s | llvm-dis | FileCheck %s

define i8 @neg1_zero(ptr %x) {
; CHECK-LABEL: 定义 整数8 @neg1_zero
; CHECK-SAME: (指针 [[X:%.*]]) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[Y:%.*]] = 加载 整数8, 指针 [[X]], 对齐 1, !range [[RNG0:![0-9]+]]
; CHECK-NEXT:    返回 整数8 [[Y]]
;
entry:
  %y = load i8, ptr %x, align 1, !range !0
  ret i8 %y
}

define <2 x i8> @neg1_zero_vector(ptr %x) {
; CHECK-LABEL: 定义 <2 个 整数8> @neg1_zero_vector
; CHECK-SAME: (指针 [[X:%.*]]) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[Y:%.*]] = 加载 <2 个 整数8>, 指针 [[X]], 对齐 1, !range [[RNG0]]
; CHECK-NEXT:    返回 <2 个 整数8> [[Y]]
;
entry:
  %y = load <2 x i8>, ptr %x, align 1, !range !0
  ret <2 x i8> %y
}

!0 = !{i8 -1, i8 0}

;.
; CHECK: [[RNG0]] = !{整数8 -1, 整数8 0}
;.
