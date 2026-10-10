; RUN: llvm-as < %s | llvm-dis | llvm-as | llvm-dis | FileCheck %s
; RUN: verify-uselistorder %s

@A = external global [2 x [3 x [5 x [7 x i32]]]]
@B = global ptr getelementptr ([2 x [3 x [5 x [7 x i32]]]], ptr @A, i64 0, i64 0, i64 2, i64 1, i64 7523)
; CHECK: @B = 全局 指针 获取元素指针 ([2 个 [3 个 [5 个 [7 个 整数32]]]], 指针 @A, 整数64 0, 整数64 0, 整数64 2, 整数64 1, 整数64 7523)
@C = global ptr getelementptr ([2 x [3 x [5 x [7 x i32]]]], ptr @A, i64 3, i64 2, i64 0, i64 0, i64 7523)
; CHECK: @C = 全局 指针 获取元素指针 ([2 个 [3 个 [5 个 [7 个 整数32]]]], 指针 @A, 整数64 3, 整数64 2, 整数64 0, 整数64 0, 整数64 7523)

; Verify that constant expression GEPs work with i84 indices.
@D = external global [1 x i32]

@E = global ptr getelementptr inbounds ([1 x i32], ptr @D, i84 0, i64 1)
; CHECK: @E = 全局 指针 获取元素指针 inbounds ([1 个 整数32], 指针 @D, 整数84 0, 整数64 1)

; Verify that i16 indices work.
@x = external global {i32, i32}
@y = global ptr getelementptr ({ i32, i32 }, ptr @x, i16 42, i32 0)
; CHECK: @y = 全局 指针 获取元素指针 ({ 整数32, 整数32 }, 指针 @x, 整数16 42, 整数32 0)

@PR23753_a = external global i8
@PR23753_b = global ptr getelementptr (i8, ptr @PR23753_a, i64 ptrtoint (ptr @PR23753_a to i64))
; CHECK: @PR23753_b = 全局 指针 获取元素指针 (整数8, 指针 @PR23753_a, 整数64 指针转整数 (指针 @PR23753_a 到 整数64))

@nestedarray = global [2 x [4 x ptr]] zeroinitializer

; CHECK: @nestedarray.1 = alias 指针, 获取元素指针 inbounds inrange(-32, 32) ([2 个 [4 个 指针]], 指针 @nestedarray, 整数32 0, 整数32 0, 整数32 4)
@nestedarray.1 = alias ptr, getelementptr inbounds inrange(-32, 32) ([2 x [4 x ptr]], ptr @nestedarray, i32 0, i32 0, i32 4)

; CHECK: @nestedarray.2 = alias 指针, 获取元素指针 inbounds inrange(0, 1) ([2 个 [4 个 指针]], 指针 @nestedarray, 整数32 0, 整数32 0, 整数32 4)
@nestedarray.2 = alias ptr, getelementptr inbounds inrange(0, 1) ([2 x [4 x ptr]], ptr @nestedarray, i32 0, i32 0, i32 4)

; CHECK: @nestedarray.3 = alias 指针, 获取元素指针 inbounds inrange(0, 4) ([4 个 指针], 指针 @nestedarray, 整数32 0, 整数32 0)
@nestedarray.3 = alias ptr, getelementptr inbounds inrange(0, 4) ([4 x ptr], ptr getelementptr inbounds ([2 x [4 x ptr]], ptr @nestedarray, i32 0, i32 0), i32 0, i32 0)

; CHECK: @nestedarray.4 = alias 指针, 获取元素指针 inbounds ([4 个 指针], 指针 获取元素指针 inbounds inrange(0, 4) ([2 个 [4 个 指针]], 指针 @nestedarray, 整数32 0, 整数32 0), 整数32 1, 整数32 0)
@nestedarray.4 = alias ptr, getelementptr inbounds ([4 x ptr], ptr getelementptr inbounds inrange(0, 4) ([2 x [4 x ptr]], ptr @nestedarray, i32 0, i32 0), i32 1, i32 0)

; CHECK: @nestedarray.5 = alias 指针, 获取元素指针 inbounds ([4 个 指针], 指针 获取元素指针 inbounds inrange(0, 32) ([2 个 [4 个 指针]], 指针 @nestedarray, 整数32 0, 整数32 0), 整数32 1, 整数32 0)
@nestedarray.5 = alias ptr, getelementptr inbounds ([4 x ptr], ptr getelementptr inbounds inrange(0, 32) ([2 x [4 x ptr]], ptr @nestedarray, i32 0, i32 0), i32 1, i32 0)

; See if i92 indices work too.
define ptr @test(ptr %t, i92 %n) {
; CHECK: @test
; CHECK: %B = 获取元素指针 { 整数32, 整数32 }, 指针 %t, 整数92 %n, 整数32 0
  %B = getelementptr {i32, i32}, ptr %t, i92 %n, i32 0
  ret ptr %B
}

; Verify that constant expression vector GEPs work.

@z = global <2 x ptr> getelementptr ([3 x {i32, i32}], <2 x ptr> zeroinitializer, <2 x i32> <i32 1, i32 2>, <2 x i32> <i32 2, i32 3>, <2 x i32> <i32 1, i32 1>)

; Verify that struct GEP works with a vector of pointers.
define <2 x ptr> @test7(<2 x ptr> %a) {
  %w = getelementptr {i32, i32}, <2 x ptr> %a, <2 x i32> <i32 5, i32 9>, <2 x i32> zeroinitializer
  ret <2 x ptr> %w
}

; Verify that array GEP works with a vector of pointers.
define <2 x ptr> @test8(<2 x ptr> %a) {
  %w = getelementptr  [2 x i8], <2 x  ptr> %a, <2 x i32> <i32 0, i32 0>, <2 x i8> <i8 0, i8 1>
  ret <2 x ptr> %w
}

@array = internal global [16 x i32] [i32 -200, i32 -199, i32 -198, i32 -197, i32 -196, i32 -195, i32 -194, i32 -193, i32 -192, i32 -191, i32 -190, i32 -189, i32 -188, i32 -187, i32 -186, i32 -185], align 16

; Verify that array GEP doesn't incorrectly infer inbounds.
define ptr @test9() {
entry:
  ret ptr getelementptr ([16 x i32], ptr @array, i64 0, i64 -13)
; CHECK-LABEL: 定义 指针 @test9(
; CHECK: 返回 指针 获取元素指针 ([16 个 整数32], 指针 @array, 整数64 0, 整数64 -13)
}
