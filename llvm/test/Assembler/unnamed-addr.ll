; RUN: llvm-as < %s | llvm-dis | FileCheck %s
; RUN: verify-uselistorder %s

%struct.foobar = type { i32 }

@bar.d = internal unnamed_addr constant %struct.foobar zeroinitializer, align 4
@foo.d = internal constant %struct.foobar zeroinitializer, align 4

define i32 @main() unnamed_addr nounwind ssp {
entry:
  %call2 = tail call i32 @zed(ptr @foo.d, ptr @bar.d) nounwind
  ret i32 0
}

declare i32 @zed(ptr, ptr)

; CHECK: @bar.d = 内部 未命名地址 常量 %struct.foobar 零初始化, 对齐 4
; CHECK: @foo.d = 内部 常量 %struct.foobar 零初始化, 对齐 4
; CHECK: 定义 整数32 @main() 未命名地址 #0 {

; CHECK: attributes #0 = { nounwind ssp }
