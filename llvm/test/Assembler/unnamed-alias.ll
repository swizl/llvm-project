; RUN: llvm-as < %s | llvm-dis | FileCheck %s

@0 = private constant i32 0
; CHECK: @0 = 私有 常量 整数32 0
@1 = private constant i32 1
; CHECK: @1 = 私有 常量 整数32 1

@2 = private alias i32, ptr @3
; CHECK: @2 = 私有 alias 整数32, 指针 @3
@3 = private alias i32, ptr @1
; CHECK: @3 = 私有 alias 整数32, 指针 @1
