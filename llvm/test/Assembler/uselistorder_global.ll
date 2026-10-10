; RUN: opt -S -preserve-ll-uselistorder < %s | FileCheck %s
; RUN: verify-uselistorder %s

; CHECK: @g = 外部 全局 整数32
; CHECK: 定义 空类型 @func1() {
; CHECK-NOT: uselistorder
; CHECK: }
; CHECK: 定义 空类型 @func2() {
; CHECK-NOT: uselistorder
; CHECK: }
; CHECK: uselistorder 指针 @g, { 3, 2, 1, 0 }

@g = external global i32

define void @func1() {
  load i32, ptr @g
  load i32, ptr @g
  ret void
}

define void @func2() {
  load i32, ptr @g
  load i32, ptr @g
  ret void
}

uselistorder ptr @g, { 3, 2, 1, 0 }
