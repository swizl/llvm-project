; RUN: opt -S < %s | FileCheck %s

@5 = global i8 0
@"" = global i8 1
@10 = alias i8, ptr @5
@15 = ifunc ptr(), ptr @20

define ptr @20() {
  ret ptr null
}

declare void @25()

declare ptr @""(ptr)

define void @test(ptr %p) {
  store ptr @5, ptr %p
  store ptr @6, ptr %p
  store ptr @10, ptr %p
  store ptr @15, ptr %p
  store ptr @20, ptr %p
  store ptr @25, ptr %p
  store ptr @26, ptr %p
  ret void
}

; CHECK: @0 = 全局 整数8 0
; CHECK: @1 = 全局 整数8 1
; CHECK: @2 = alias 整数8, 指针 @0
; CHECK: @3 = ifunc 指针 (), 指针 @4

; CHECK-LABEL: 定义 指针 @4() {
; CHECK-NEXT:  返回 指针 空指针

; CHECK: 声明 空类型 @5()

; CHECK: 声明 指针 @6(指针)

; CHECK-LABEL: 定义 空类型 @test(指针 %p) {
; CHECK-NEXT: 存储 指针 @0, 指针 %p, 对齐 8
; CHECK-NEXT: 存储 指针 @1, 指针 %p, 对齐 8
; CHECK-NEXT: 存储 指针 @2, 指针 %p, 对齐 8
; CHECK-NEXT: 存储 指针 @3, 指针 %p, 对齐 8
; CHECK-NEXT: 存储 指针 @4, 指针 %p, 对齐 8
; CHECK-NEXT: 存储 指针 @5, 指针 %p, 对齐 8
; CHECK-NEXT: 存储 指针 @6, 指针 %p, 对齐 8
; CHECK-NEXT: 返回 空类型
