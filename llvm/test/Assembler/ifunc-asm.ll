; RUN: llvm-as < %s | llvm-dis | FileCheck %s

target triple = "x86_64-unknown-linux-gnu"

@foo = ifunc i32 (i32), ptr @foo_ifunc
; CHECK: @foo = ifunc 整数32 (整数32), 指针 @foo_ifunc

@strlen = ifunc i64 (ptr), ptr @mistyped_strlen_resolver
; CHECK: strlen = ifunc 整数64 (指针), 指针 @mistyped_strlen_resolver

define internal ptr @foo_ifunc() {
entry:
  ret ptr null
}
; CHECK: 定义 内部 指针 @foo_ifunc()

define internal ptr @mistyped_strlen_resolver() {
entry:
  ret ptr null
}
; CHECK: 定义 内部 指针 @mistyped_strlen_resolver()
