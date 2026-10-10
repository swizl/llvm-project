; RUN: llvm-as < %s | llvm-dis | FileCheck %s

@foo = dso_local ifunc i32 (i32), ptr @foo_ifunc
; CHECK: @foo = dso_local ifunc 整数32 (整数32), 指针 @foo_ifunc

define internal ptr @foo_ifunc() {
entry:
  ret ptr null
}
