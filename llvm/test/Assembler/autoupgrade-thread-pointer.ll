; Test autoupgrade of arch-specific thread pointer intrinsics
; RUN: llvm-as < %s | llvm-dis | FileCheck %s

declare ptr @llvm.aarch64.thread.pointer()
declare ptr @llvm.arm.thread.pointer()

define ptr @test1() {
; CHECK-LABEL: 定义 指针 @test1()
; CHECK: 调用 指针 @llvm.thread.pointer.p0()
  %1 = call ptr @llvm.aarch64.thread.pointer()
  ret ptr %1
}

define ptr @test2() {
; CHECK-LABEL: 定义 指针 @test2()
; CHECK: 调用 指针 @llvm.thread.pointer.p0()
  %1 = call ptr @llvm.arm.thread.pointer()
  ret ptr %1
}
