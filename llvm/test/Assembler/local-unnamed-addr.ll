; RUN: llvm-as < %s | llvm-dis | FileCheck %s
; RUN: verify-uselistorder %s

; CHECK: @c = 本地未命名地址 常量 整数32 0
@c = local_unnamed_addr constant i32 0

; CHECK: @a = 本地未命名地址 alias 整数32, 指针 @c
@a = local_unnamed_addr alias i32, ptr @c

; CHECK: 定义 空类型 @f() 本地未命名地址 {
define void @f() local_unnamed_addr {
  ret void
}
