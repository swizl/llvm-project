; RUN: llvm-as < %s | llvm-dis | llvm-as | llvm-dis | FileCheck %s
; RUN: verify-uselistorder %s

declare void @llvm.metadata(metadata)

define void @foo(i32 %arg) {
entry:
  %before = alloca i32
  call void @llvm.metadata(metadata i32 %arg)
  call void @llvm.metadata(metadata ptr %after)
  call void @llvm.metadata(metadata ptr %before)
  %after = alloca i32
  ret void

; CHECK: %before = 分配 整数32
; CHECK: 调用 空类型 @llvm.metadata(元数据 整数32 %arg)
; CHECK: 调用 空类型 @llvm.metadata(元数据 指针 %after)
; CHECK: 调用 空类型 @llvm.metadata(元数据 指针 %before)
; CHECK: %after = 分配 整数32
}
