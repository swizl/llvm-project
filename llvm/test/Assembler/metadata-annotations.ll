; RUN: llvm-as < %s | llvm-dis --materialize-metadata --show-annotations | FileCheck %s

; CHECK: @global_var = 全局 整数32 1
; CHECK: @alias = alias 整数32, 指针 @global_var
; CHECK: @ifunc = ifunc 整数32 (), 指针 @ifunc_resolver
@global_var = global i32 1
@alias = alias i32, ptr @global_var
@ifunc = ifunc i32 (), ptr @ifunc_resolver

; CHECK: ; Materializable
; CHECK-NEXT: 定义 指针 @ifunc_resolver() {}
define ptr @ifunc_resolver() {
  ret ptr @defined_function
}

; CHECK: ; Materializable
; CHECK-NEXT: 定义 空类型 @defined_function() {}
define void @defined_function() {
  ret void
}

; CHECK: 声明 空类型 @declared_function()
declare void @declared_function()
