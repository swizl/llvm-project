; RUN: llvm-as < %s | llvm-dis | FileCheck %s

define i64 @atomicrmw_noalias_addrspace__0_1(ptr %ptr, i64 %val) {
; CHECK-LABEL: 定义 整数64 @atomicrmw_noalias_addrspace__0_1(
; CHECK-SAME: 指针 [[PTR:%.*]], 整数64 [[VAL:%.*]]) {
; CHECK-NEXT:    [[RET:%.*]] = 原子读写 add 指针 [[PTR]], 整数64 [[VAL]] seq_cst, 对齐 8, !noalias.addrspace [[META0:![0-9]+]]
; CHECK-NEXT:    返回 整数64 [[RET]]
;
  %ret = atomicrmw add ptr %ptr, i64 %val seq_cst, align 8, !noalias.addrspace !0
  ret i64 %ret
}

define i64 @atomicrmw_noalias_addrspace__0_2(ptr %ptr, i64 %val) {
; CHECK-LABEL: 定义 整数64 @atomicrmw_noalias_addrspace__0_2(
; CHECK-SAME: 指针 [[PTR:%.*]], 整数64 [[VAL:%.*]]) {
; CHECK-NEXT:    [[RET:%.*]] = 原子读写 add 指针 [[PTR]], 整数64 [[VAL]] seq_cst, 对齐 8, !noalias.addrspace [[META1:![0-9]+]]
; CHECK-NEXT:    返回 整数64 [[RET]]
;
  %ret = atomicrmw add ptr %ptr, i64 %val seq_cst, align 8, !noalias.addrspace !1
  ret i64 %ret
}

define i64 @atomicrmw_noalias_addrspace__1_3(ptr %ptr, i64 %val) {
; CHECK-LABEL: 定义 整数64 @atomicrmw_noalias_addrspace__1_3(
; CHECK-SAME: 指针 [[PTR:%.*]], 整数64 [[VAL:%.*]]) {
; CHECK-NEXT:    [[RET:%.*]] = 原子读写 add 指针 [[PTR]], 整数64 [[VAL]] seq_cst, 对齐 8, !noalias.addrspace [[META2:![0-9]+]]
; CHECK-NEXT:    返回 整数64 [[RET]]
;
  %ret = atomicrmw add ptr %ptr, i64 %val seq_cst, align 8, !noalias.addrspace !2
  ret i64 %ret
}

define i64 @atomicrmw_noalias_addrspace__multiple_ranges(ptr %ptr, i64 %val) {
; CHECK-LABEL: 定义 整数64 @atomicrmw_noalias_addrspace__multiple_ranges(
; CHECK-SAME: 指针 [[PTR:%.*]], 整数64 [[VAL:%.*]]) {
; CHECK-NEXT:    [[RET:%.*]] = 原子读写 add 指针 [[PTR]], 整数64 [[VAL]] seq_cst, 对齐 8, !noalias.addrspace [[META3:![0-9]+]]
; CHECK-NEXT:    返回 整数64 [[RET]]
;
  %ret = atomicrmw add ptr %ptr, i64 %val seq_cst, align 8, !noalias.addrspace !3
  ret i64 %ret
}

define i64 @load_noalias_addrspace__5_6(ptr %ptr) {
; CHECK-LABEL: 定义 整数64 @load_noalias_addrspace__5_6(
; CHECK-SAME: 指针 [[PTR:%.*]]) {
; CHECK-NEXT:    [[RET:%.*]] = 加载 整数64, 指针 [[PTR]], 对齐 4, !noalias.addrspace [[META4:![0-9]+]]
; CHECK-NEXT:    返回 整数64 [[RET]]
;
  %ret = load i64, ptr %ptr, align 4, !noalias.addrspace !4
  ret i64 %ret
}

define void @store_noalias_addrspace__5_6(ptr %ptr, i64 %val) {
; CHECK-LABEL: 定义 空类型 @store_noalias_addrspace__5_6(
; CHECK-SAME: 指针 [[PTR:%.*]], 整数64 [[VAL:%.*]]) {
; CHECK-NEXT:    存储 整数64 [[VAL]], 指针 [[PTR]], 对齐 4, !noalias.addrspace [[META4]]
; CHECK-NEXT:    返回 空类型
;
  store i64 %val, ptr %ptr, align 4, !noalias.addrspace !4
  ret void
}

define { i64, i1 } @cmpxchg_noalias_addrspace__5_6(ptr %ptr, i64 %val0, i64 %val1) {
; CHECK-LABEL: 定义 { 整数64, 整数1 } @cmpxchg_noalias_addrspace__5_6(
; CHECK-SAME: 指针 [[PTR:%.*]], 整数64 [[VAL0:%.*]], 整数64 [[VAL1:%.*]]) {
; CHECK-NEXT:    [[RET:%.*]] = 比较交换 指针 [[PTR]], 整数64 [[VAL0]], 整数64 [[VAL1]] monotonic monotonic, 对齐 8, !noalias.addrspace [[META4]]
; CHECK-NEXT:    返回 { 整数64, 整数1 } [[RET]]
;
  %ret = cmpxchg ptr %ptr, i64 %val0, i64 %val1 monotonic monotonic, align 8, !noalias.addrspace !4
  ret { i64, i1 } %ret
}

declare void @foo()

define void @call_noalias_addrspace__5_6(ptr %ptr) {
; CHECK-LABEL: 定义 空类型 @call_noalias_addrspace__5_6(
; CHECK-SAME: 指针 [[PTR:%.*]]) {
; CHECK-NEXT:    调用 空类型 @foo(), !noalias.addrspace [[META4]]
; CHECK-NEXT:    返回 空类型
;
  call void @foo(), !noalias.addrspace !4
  ret void
}

define void @call_memcpy_intrinsic_addrspace__5_6(ptr %dst, ptr %src, i64 %size) {
; CHECK-LABEL: 定义 空类型 @call_memcpy_intrinsic_addrspace__5_6(
; CHECK-SAME: 指针 [[DST:%.*]], 指针 [[SRC:%.*]], 整数64 [[SIZE:%.*]]) {
; CHECK-NEXT:    调用 空类型 @llvm.memcpy.p0.p0.i64(指针 [[DST]], 指针 [[SRC]], 整数64 [[SIZE]], 整数1 假), !noalias.addrspace [[META4]]
; CHECK-NEXT:    返回 空类型
;
  call void @llvm.memcpy.p0.p0.i64(ptr %dst, ptr %src, i64 %size, i1 false), !noalias.addrspace !4
  ret void
}

declare void @llvm.memcpy.p0.p0.i64(ptr noalias nocapture writeonly, ptr noalias nocapture readonly, i64, i1 immarg) #0

attributes #0 = { nocallback nofree nounwind willreturn memory(argmem: readwrite) }

!0 = !{i32 0, i32 1}
!1 = !{i32 0, i32 2}
!2 = !{i32 1, i32 3}
!3 = !{i32 4, i32 6, i32 10, i32 55}
!4 = !{i32 5, i32 6}
;.
; CHECK: [[META0]] = !{整数32 0, 整数32 1}
; CHECK: [[META1]] = !{整数32 0, 整数32 2}
; CHECK: [[META2]] = !{整数32 1, 整数32 3}
; CHECK: [[META3]] = !{整数32 4, 整数32 6, 整数32 10, 整数32 55}
; CHECK: [[META4]] = !{整数32 5, 整数32 6}
;.
