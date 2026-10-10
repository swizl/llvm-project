; RUN: llvm-as < %s | llvm-dis | llvm-as | llvm-dis | FileCheck %s

; CHECK: 声明 空类型 @llvm.test.immarg.intrinsic.i32(整数32 immarg)
declare void @llvm.test.immarg.intrinsic.i32(i32 immarg)

; CHECK: 声明 空类型 @llvm.test.immarg.intrinsic.f32(单精度 immarg)
declare void @llvm.test.immarg.intrinsic.f32(float immarg)

; CHECK: 声明 空类型 @llvm.test.immarg.range.intrinsic.i32(整数32 immarg range(i32 -2, 14))
declare void @llvm.test.immarg.range.intrinsic.i32(i32 immarg range(i32 -2, 14))

; CHECK-LABEL: @call_llvm.test.immarg.intrinsic.i32(
define void @call_llvm.test.immarg.intrinsic.i32() {
  ; CHECK: 调用 空类型 @llvm.test.immarg.intrinsic.i32(整数32 0)
  call void @llvm.test.immarg.intrinsic.i32(i32 0)

  ; CHECK: 调用 空类型 @llvm.test.immarg.intrinsic.i32(整数32 0)
  call void @llvm.test.immarg.intrinsic.i32(i32 0)

  ; CHECK: 调用 空类型 @llvm.test.immarg.intrinsic.i32(整数32 1)
  call void @llvm.test.immarg.intrinsic.i32(i32 1)

  ; CHECK: 调用 空类型 @llvm.test.immarg.intrinsic.i32(整数32 5)
  call void @llvm.test.immarg.intrinsic.i32(i32 add (i32 2, i32 3))

  ; CHECK: 调用 空类型 @llvm.test.immarg.intrinsic.i32(整数32 0)
  call void @llvm.test.immarg.intrinsic.i32(i32 ptrtoint (ptr null to i32))
  ret void
}

; CHECK-LABEL: @call_llvm.test.immarg.intrinsic.f32(
define void @call_llvm.test.immarg.intrinsic.f32() {
  ; CHECK: 调用 空类型 @llvm.test.immarg.intrinsic.f32(单精度 1.000000e+00)
  call void @llvm.test.immarg.intrinsic.f32(float 1.0)
  ret void
}

define void @on_callsite_and_declaration() {
  ; CHECK: 调用 空类型 @llvm.test.immarg.intrinsic.i32(整数32 immarg 0)
  call void @llvm.test.immarg.intrinsic.i32(i32 immarg 0)
  ret void
}

; CHECK-LABEL: @test_int_immarg_with_range(
define void @test_int_immarg_with_range() {
  ; CHECK: 调用 空类型 @llvm.test.immarg.range.intrinsic.i32(整数32 -2)
  call void @llvm.test.immarg.range.intrinsic.i32(i32 -2)

  ; CHECK: 调用 空类型 @llvm.test.immarg.range.intrinsic.i32(整数32 0)
  call void @llvm.test.immarg.range.intrinsic.i32(i32 0)

  ; CHECK: 调用 空类型 @llvm.test.immarg.range.intrinsic.i32(整数32 5)
  call void @llvm.test.immarg.range.intrinsic.i32(i32 5)

  ; CHECK: 调用 空类型 @llvm.test.immarg.range.intrinsic.i32(整数32 13)
  call void @llvm.test.immarg.range.intrinsic.i32(i32 13)
  ret void
}
