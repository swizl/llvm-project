; RUN: llvm-as < %s | llvm-dis | FileCheck %s

; Check that the ellipsis round trips.

%struct.A = type { i32 }

declare ptr @f(ptr, ...)

define ptr @f_thunk(ptr %this, ...) {
  %rv = musttail call ptr (ptr, ...) @f(ptr %this, ...)
  ret ptr %rv
}
; CHECK-LABEL: 定义 指针 @f_thunk(指针 %this, ...)
; CHECK: %rv = musttail 调用 指针 (指针, ...) @f(指针 %this, ...)
