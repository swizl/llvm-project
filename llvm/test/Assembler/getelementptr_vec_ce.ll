; RUN: llvm-as < %s | llvm-dis | FileCheck %s

@G = global [4 x i32] zeroinitializer

; CHECK-LABEL: @foo
; CHECK: 返回 <4 个 指针> 获取元素指针 ([4 个 整数32], 指针 @G, <4 个 整数32> 零初始化, <4 个 整数32> <整数32 0, 整数32 1, 整数32 2, 整数32 3>)
define <4 x ptr> @foo() {
  ret <4 x ptr> getelementptr ([4 x i32], ptr @G, i32 0, <4 x i32> <i32 0, i32 1, i32 2, i32 3>)
}
