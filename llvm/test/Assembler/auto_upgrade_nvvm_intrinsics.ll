; Test to make sure NVVM intrinsics are automatically upgraded.
; RUN: llvm-as < %s | llvm-dis | FileCheck %s
; RUN: verify-uselistorder %s

declare i32 @llvm.nvvm.brev32(i32)
declare i64 @llvm.nvvm.brev64(i64)
declare i32 @llvm.nvvm.clz.i(i32)
declare i32 @llvm.nvvm.clz.ll(i64)
declare i32 @llvm.nvvm.popc.i(i32)
declare i32 @llvm.nvvm.popc.ll(i64)
declare float @llvm.nvvm.h2f(i16)

declare i32 @llvm.nvvm.abs.i(i32)
declare i64 @llvm.nvvm.abs.ll(i64)

declare float @llvm.nvvm.fabs.f(float)
declare float @llvm.nvvm.fabs.ftz.f(float)
declare double @llvm.nvvm.fabs.d(double)

declare float @llvm.nvvm.tanh.approx.f32(float)

declare i16 @llvm.nvvm.max.s(i16, i16)
declare i32 @llvm.nvvm.max.i(i32, i32)
declare i64 @llvm.nvvm.max.ll(i64, i64)
declare i16 @llvm.nvvm.max.us(i16, i16)
declare i32 @llvm.nvvm.max.ui(i32, i32)
declare i64 @llvm.nvvm.max.ull(i64, i64)
declare i16 @llvm.nvvm.min.s(i16, i16)
declare i32 @llvm.nvvm.min.i(i32, i32)
declare i64 @llvm.nvvm.min.ll(i64, i64)
declare i16 @llvm.nvvm.min.us(i16, i16)
declare i32 @llvm.nvvm.min.ui(i32, i32)
declare i64 @llvm.nvvm.min.ull(i64, i64)

declare i32 @llvm.nvvm.bitcast.f2i(float)
declare float @llvm.nvvm.bitcast.i2f(i32)
declare i64 @llvm.nvvm.bitcast.d2ll(double)
declare double @llvm.nvvm.bitcast.ll2d(i64)

declare i32 @llvm.nvvm.rotate.b32(i32, i32)
declare i64 @llvm.nvvm.rotate.right.b64(i64, i32)
declare i64 @llvm.nvvm.rotate.b64(i64, i32)
declare i64 @llvm.nvvm.swap.lo.hi.b64(i64)

declare ptr addrspace(1) @llvm.nvvm.ptr.gen.to.global.p1.p0(ptr)
declare ptr addrspace(3) @llvm.nvvm.ptr.gen.to.shared.p3.p0(ptr)
declare ptr addrspace(4) @llvm.nvvm.ptr.gen.to.constant.p4.p0(ptr)
declare ptr addrspace(5) @llvm.nvvm.ptr.gen.to.local.p5.p0(ptr)
declare ptr addrspace(101) @llvm.nvvm.ptr.gen.to.param.p101.p0(ptr)
declare ptr @llvm.nvvm.ptr.global.to.gen.p0.p1(ptr addrspace(1))
declare ptr @llvm.nvvm.ptr.shared.to.gen.p0.p3(ptr addrspace(3))
declare ptr @llvm.nvvm.ptr.constant.to.gen.p0.p4(ptr addrspace(4))
declare ptr @llvm.nvvm.ptr.local.to.gen.p0.p5(ptr addrspace(5))
declare ptr @llvm.nvvm.ptr.param.to.gen.p0.p101(ptr addrspace(101))

declare i32 @llvm.nvvm.ldg.global.i.i32.p1(ptr addrspace(1), i32)
declare ptr @llvm.nvvm.ldg.global.p.p1(ptr addrspace(1), i32)
declare float @llvm.nvvm.ldg.global.f.f32.p1(ptr addrspace(1), i32)
declare i32 @llvm.nvvm.ldg.global.i.i32.p0(ptr, i32)
declare ptr @llvm.nvvm.ldg.global.p.p0(ptr, i32)
declare float @llvm.nvvm.ldg.global.f.f32.p0(ptr, i32)

declare i32 @llvm.nvvm.atomic.load.inc.32.p0(ptr, i32)
declare i32 @llvm.nvvm.atomic.load.dec.32.p0(ptr, i32)
declare i32 @llvm.nvvm.atomic.load.add.f32.p0(ptr, float)
declare i32 @llvm.nvvm.atomic.load.add.f64.p0(ptr, double)

declare i32 @llvm.nvvm.atomic.add.gen.i.cta.i32.p0(ptr, i32)
declare i64 @llvm.nvvm.atomic.add.gen.i.cta.i64.p0(ptr, i64)
declare i32 @llvm.nvvm.atomic.add.gen.i.sys.i32.p0(ptr, i32)
declare i64 @llvm.nvvm.atomic.add.gen.i.sys.i64.p0(ptr, i64)
declare i32 @llvm.nvvm.atomic.exch.gen.i.cta.i32.p0(ptr, i32)
declare i64 @llvm.nvvm.atomic.exch.gen.i.cta.i64.p0(ptr, i64)
declare i32 @llvm.nvvm.atomic.exch.gen.i.sys.i32.p0(ptr, i32)
declare i64 @llvm.nvvm.atomic.exch.gen.i.sys.i64.p0(ptr, i64)
declare i32 @llvm.nvvm.atomic.max.gen.i.cta.i32.p0(ptr, i32)
declare i64 @llvm.nvvm.atomic.max.gen.i.cta.i64.p0(ptr, i64)
declare i32 @llvm.nvvm.atomic.max.gen.i.sys.i32.p0(ptr, i32)
declare i64 @llvm.nvvm.atomic.max.gen.i.sys.i64.p0(ptr, i64)
declare i32 @llvm.nvvm.atomic.min.gen.i.cta.i32.p0(ptr, i32)
declare i64 @llvm.nvvm.atomic.min.gen.i.cta.i64.p0(ptr, i64)
declare i32 @llvm.nvvm.atomic.min.gen.i.sys.i32.p0(ptr, i32)
declare i64 @llvm.nvvm.atomic.min.gen.i.sys.i64.p0(ptr, i64)
declare i32 @llvm.nvvm.atomic.inc.gen.i.cta.i32.p0(ptr, i32)
declare i64 @llvm.nvvm.atomic.inc.gen.i.cta.i64.p0(ptr, i64)
declare i32 @llvm.nvvm.atomic.inc.gen.i.sys.i32.p0(ptr, i32)
declare i64 @llvm.nvvm.atomic.inc.gen.i.sys.i64.p0(ptr, i64)
declare i32 @llvm.nvvm.atomic.dec.gen.i.cta.i32.p0(ptr, i32)
declare i64 @llvm.nvvm.atomic.dec.gen.i.cta.i64.p0(ptr, i64)
declare i32 @llvm.nvvm.atomic.dec.gen.i.sys.i32.p0(ptr, i32)
declare i64 @llvm.nvvm.atomic.dec.gen.i.sys.i64.p0(ptr, i64)
declare i32 @llvm.nvvm.atomic.and.gen.i.cta.i32.p0(ptr, i32)
declare i64 @llvm.nvvm.atomic.and.gen.i.cta.i64.p0(ptr, i64)
declare i32 @llvm.nvvm.atomic.and.gen.i.sys.i32.p0(ptr, i32)
declare i64 @llvm.nvvm.atomic.and.gen.i.sys.i64.p0(ptr, i64)
declare i32 @llvm.nvvm.atomic.or.gen.i.cta.i32.p0(ptr, i32)
declare i64 @llvm.nvvm.atomic.or.gen.i.cta.i64.p0(ptr, i64)
declare i32 @llvm.nvvm.atomic.or.gen.i.sys.i32.p0(ptr, i32)
declare i64 @llvm.nvvm.atomic.or.gen.i.sys.i64.p0(ptr, i64)
declare i32 @llvm.nvvm.atomic.xor.gen.i.cta.i32.p0(ptr, i32)
declare i64 @llvm.nvvm.atomic.xor.gen.i.cta.i64.p0(ptr, i64)
declare i32 @llvm.nvvm.atomic.xor.gen.i.sys.i32.p0(ptr, i32)
declare i64 @llvm.nvvm.atomic.xor.gen.i.sys.i64.p0(ptr, i64)
declare i32 @llvm.nvvm.atomic.cas.gen.i.cta.i32.p0(ptr, i32, i32)
declare i64 @llvm.nvvm.atomic.cas.gen.i.cta.i64.p0(ptr, i64, i64)
declare i32 @llvm.nvvm.atomic.cas.gen.i.sys.i32.p0(ptr, i32, i32)
declare i64 @llvm.nvvm.atomic.cas.gen.i.sys.i64.p0(ptr, i64, i64)
declare float @llvm.nvvm.atomic.add.gen.f.cta.f32.p0(ptr, float)
declare double @llvm.nvvm.atomic.add.gen.f.cta.f64.p0(ptr, double)
declare float @llvm.nvvm.atomic.add.gen.f.sys.f32.p0(ptr, float)
declare double @llvm.nvvm.atomic.add.gen.f.sys.f64.p0(ptr, double)

declare ptr addrspace(3) @llvm.nvvm.mapa.shared.cluster(ptr addrspace(3), i32)

declare void @llvm.nvvm.cp.async.bulk.global.to.shared.cluster(ptr addrspace(3), ptr addrspace(3), ptr addrspace(1), i32, i16, i64, i1, i1)
declare void @llvm.nvvm.cp.async.bulk.shared.cta.to.cluster(ptr addrspace(3), ptr addrspace(3), ptr addrspace(3), i32)

declare void @llvm.nvvm.cp.async.bulk.tensor.g2s.tile.1d(ptr addrspace(3) %d, ptr addrspace(3) %bar, ptr %tm, i32 %d0, i16 %mc, i64 %ch, i1 %f1, i1 %f2);
declare void @llvm.nvvm.cp.async.bulk.tensor.g2s.tile.2d(ptr addrspace(3) %d, ptr addrspace(3) %bar, ptr %tm, i32 %d0, i32 %d1, i16 %mc, i64 %ch, i1 %f1, i1 %f2);
declare void @llvm.nvvm.cp.async.bulk.tensor.g2s.tile.3d(ptr addrspace(3) %d, ptr addrspace(3) %bar, ptr %tm, i32 %d0, i32 %d1, i32 %d2, i16 %mc, i64 %ch, i1 %f1, i1 %f2);
declare void @llvm.nvvm.cp.async.bulk.tensor.g2s.tile.4d(ptr addrspace(3) %d, ptr addrspace(3) %bar, ptr %tm, i32 %d0, i32 %d1, i32 %d2, i32 %d3, i16 %mc, i64 %ch, i1 %f1, i1 %f2);
declare void @llvm.nvvm.cp.async.bulk.tensor.g2s.tile.5d(ptr addrspace(3) %d, ptr addrspace(3) %bar, ptr %tm, i32 %d0, i32 %d1, i32 %d2, i32 %d3, i32 %d4, i16 %mc, i64 %ch, i1 %f1, i1 %f2);

declare void @llvm.nvvm.cp.async.bulk.tensor.g2s.im2col.3d(ptr addrspace(3) %d, ptr addrspace(3) %bar, ptr %tm, i32 %d0, i32 %d1, i32 %d2, i16 %im2col0, i16 %mc, i64 %ch, i1 %f1, i1 %f2);
declare void @llvm.nvvm.cp.async.bulk.tensor.g2s.im2col.4d(ptr addrspace(3) %d, ptr addrspace(3) %bar, ptr %tm, i32 %d0, i32 %d1, i32 %d2, i32 %d3, i16 %im2col0, i16 %im2col1, i16 %mc, i64 %ch, i1 %f1, i1 %f2);
declare void @llvm.nvvm.cp.async.bulk.tensor.g2s.im2col.5d(ptr addrspace(3) %d, ptr addrspace(3) %bar, ptr %tm, i32 %d0, i32 %d1, i32 %d2, i32 %d3, i32 %d4, i16 %im2col0, i16 %im2col1, i16 %im2col2, i16 %mc, i64 %ch, i1 %f1, i1 %f2);

declare void @llvm.nvvm.barrier0()
declare void @llvm.nvvm.barrier.n(i32)
declare void @llvm.nvvm.bar.sync(i32)
declare void @llvm.nvvm.barrier(i32, i32)
declare void @llvm.nvvm.barrier.sync(i32)
declare void @llvm.nvvm.barrier.sync.cnt(i32, i32)

declare i32 @llvm.nvvm.barrier0.popc(i32)
declare i32 @llvm.nvvm.barrier0.and(i32)
declare i32 @llvm.nvvm.barrier0.or(i32)

declare float @llvm.nvvm.ex2.approx.f(float)
declare double @llvm.nvvm.ex2.approx.d(double)
declare <2 x half> @llvm.nvvm.ex2.approx.f16x2(<2 x half>)
declare float @llvm.nvvm.ex2.approx.ftz.f(float)

; CHECK-LABEL: @simple_upgrade
define void @simple_upgrade(i32 %a, i64 %b, i16 %c) {
; CHECK: 调用 整数32 @llvm.bitreverse.i32(整数32 %a)
  %r1 = call i32 @llvm.nvvm.brev32(i32 %a)

; CHECK: 调用 整数64 @llvm.bitreverse.i64(整数64 %b)
  %r2 = call i64 @llvm.nvvm.brev64(i64 %b)

; CHECK: 调用 整数32 @llvm.ctlz.i32(整数32 %a, 整数1 假)
  %r3 = call i32 @llvm.nvvm.clz.i(i32 %a)

; CHECK: [[clz:%[a-zA-Z0-9.]+]] = 调用 整数64 @llvm.ctlz.i64(整数64 %b, 整数1 假)
; CHECK: 截断 整数64 [[clz]] 到 整数32
  %r4 = call i32 @llvm.nvvm.clz.ll(i64 %b)

; CHECK: 调用 整数32 @llvm.ctpop.i32(整数32 %a)
  %r5 = call i32 @llvm.nvvm.popc.i(i32 %a)

; CHECK: [[popc:%[a-zA-Z0-9.]+]] = 调用 整数64 @llvm.ctpop.i64(整数64 %b)
; CHECK: 截断 整数64 [[popc]] 到 整数32
  %r6 = call i32 @llvm.nvvm.popc.ll(i64 %b)

; CHECK: [[BITCAST_C:%.+]] = 位转换 整数16 %c 到 半精度
; CHECK-NEXT: = 浮点扩展 半精度 [[BITCAST_C]] 到 单精度
  %r7 = call float @llvm.nvvm.h2f(i16 %c)
  ret void
}

; CHECK-LABEL: @abs
define void @abs(i32 %a, i64 %b) {
; CHECK: 调用 整数32 @llvm.abs.i32(整数32 %a, 整数1 真)
  %r1 = call i32 @llvm.nvvm.abs.i(i32 %a)

; CHECK: 调用 整数64 @llvm.abs.i64(整数64 %b, 整数1 真)
  %r2 = call i64 @llvm.nvvm.abs.ll(i64 %b)

  ret void
}

; CHECK-LABEL: @fabs
define void @fabs(float %a, double %b) {
; CHECK: 调用 单精度 @llvm.nvvm.fabs.f32(单精度 %a)
; CHECK: 调用 单精度 @llvm.nvvm.fabs.ftz.f32(单精度 %a)
; CHECK: 调用 双精度 @llvm.nvvm.fabs.f64(双精度 %b)
  %r1 = call float @llvm.nvvm.fabs.f(float %a)
  %r2 = call float @llvm.nvvm.fabs.ftz.f(float %a)
  %r3 = call double @llvm.nvvm.fabs.d(double %b)
  ret void
}

; CHECK-LABEL: @tanh
define void @tanh(float %a) {
; CHECK: 调用 afn 单精度 @llvm.tanh.f32(单精度 %a)
  %r1 = call float @llvm.nvvm.tanh.approx.f32(float %a)
  ret void
}

; CHECK-LABEL: @min_max
define void @min_max(i16 %a1, i16 %a2, i32 %b1, i32 %b2, i64 %c1, i64 %c2) {
; CHECK: %r1 = 调用 整数16 @llvm.smax.i16(整数16 %a1, 整数16 %a2)
  %r1 = call i16 @llvm.nvvm.max.s(i16 %a1, i16 %a2)

; CHECK: %r2 = 调用 整数32 @llvm.smax.i32(整数32 %b1, 整数32 %b2)
  %r2 = call i32 @llvm.nvvm.max.i(i32 %b1, i32 %b2)

; CHECK: %r3 = 调用 整数64 @llvm.smax.i64(整数64 %c1, 整数64 %c2)
  %r3 = call i64 @llvm.nvvm.max.ll(i64 %c1, i64 %c2)

; CHECK: %r4 = 调用 整数16 @llvm.umax.i16(整数16 %a1, 整数16 %a2)
  %r4 = call i16 @llvm.nvvm.max.us(i16 %a1, i16 %a2)

; CHECK: %r5 = 调用 整数32 @llvm.umax.i32(整数32 %b1, 整数32 %b2)
  %r5 = call i32 @llvm.nvvm.max.ui(i32 %b1, i32 %b2)

; CHECK: %r6 = 调用 整数64 @llvm.umax.i64(整数64 %c1, 整数64 %c2)
  %r6 = call i64 @llvm.nvvm.max.ull(i64 %c1, i64 %c2)

; CHECK: %r7 = 调用 整数16 @llvm.smin.i16(整数16 %a1, 整数16 %a2)
  %r7 = call i16 @llvm.nvvm.min.s(i16 %a1, i16 %a2)

; CHECK: %r8 = 调用 整数32 @llvm.smin.i32(整数32 %b1, 整数32 %b2)
  %r8 = call i32 @llvm.nvvm.min.i(i32 %b1, i32 %b2)

; CHECK: %r9 = 调用 整数64 @llvm.smin.i64(整数64 %c1, 整数64 %c2)
  %r9 = call i64 @llvm.nvvm.min.ll(i64 %c1, i64 %c2)

; CHECK: %r10 = 调用 整数16 @llvm.umin.i16(整数16 %a1, 整数16 %a2)
  %r10 = call i16 @llvm.nvvm.min.us(i16 %a1, i16 %a2)

; CHECK: %r11 = 调用 整数32 @llvm.umin.i32(整数32 %b1, 整数32 %b2)
  %r11 = call i32 @llvm.nvvm.min.ui(i32 %b1, i32 %b2)

; CHECK: %r12 = 调用 整数64 @llvm.umin.i64(整数64 %c1, 整数64 %c2)
  %r12 = call i64 @llvm.nvvm.min.ull(i64 %c1, i64 %c2)

  ret void
}

; CHECK-LABEL: @bitcast
define void @bitcast(i32 %a, i64 %b, float %c, double %d) {
; CHECK: 位转换 单精度 %c 到 整数32
; CHECK: 位转换 整数32 %a 到 单精度
; CHECK: 位转换 双精度 %d 到 整数64
; CHECK: 位转换 整数64 %b 到 双精度
;
  %r1 = call i32 @llvm.nvvm.bitcast.f2i(float %c)
  %r2 = call float @llvm.nvvm.bitcast.i2f(i32 %a)
  %r3 = call i64 @llvm.nvvm.bitcast.d2ll(double %d)
  %r4 = call double @llvm.nvvm.bitcast.ll2d(i64 %b)

  ret void
}

; CHECK-LABEL: @rotate
define void @rotate(i32 %a, i64 %b) {
; CHECK: 调用 整数32 @llvm.fshl.i32(整数32 %a, 整数32 %a, 整数32 6)
; CHECK: 调用 整数64 @llvm.fshr.i64(整数64 %b, 整数64 %b, 整数64 7)
; CHECK: 调用 整数64 @llvm.fshl.i64(整数64 %b, 整数64 %b, 整数64 8)
; CHECK: 调用 整数64 @llvm.fshl.i64(整数64 %b, 整数64 %b, 整数64 32)
;
  %r1 = call i32 @llvm.nvvm.rotate.b32(i32 %a, i32 6)
  %r2 = call i64 @llvm.nvvm.rotate.right.b64(i64 %b, i32 7)
  %r3 = call i64 @llvm.nvvm.rotate.b64(i64 %b, i32 8)
  %r4 = call i64 @llvm.nvvm.swap.lo.hi.b64(i64 %b)
  ret void
}

; CHECK-LABEL: @addrspacecast
define void @addrspacecast(ptr %p0) {
; CHECK: %1 = 地址空间转换 指针 %p0 到 指针 addrspace(1)
; CHECK: %2 = 地址空间转换 指针 addrspace(1) %1 到 指针
; CHECK: %3 = 地址空间转换 指针 %2 到 指针 addrspace(3)
; CHECK: %4 = 地址空间转换 指针 addrspace(3) %3 到 指针
; CHECK: %5 = 地址空间转换 指针 %4 到 指针 addrspace(4)
; CHECK: %6 = 地址空间转换 指针 addrspace(4) %5 到 指针
; CHECK: %7 = 地址空间转换 指针 %6 到 指针 addrspace(5)
; CHECK: %8 = 地址空间转换 指针 addrspace(5) %7 到 指针
; CHECK: %9 = 地址空间转换 指针 %8 到 指针 addrspace(101)
; CHECK: %10 = 地址空间转换 指针 addrspace(101) %9 到 指针
;
  %p1 = call ptr addrspace(1) @llvm.nvvm.ptr.gen.to.global.p1.p0(ptr %p0)
  %p2 = call ptr @llvm.nvvm.ptr.global.to.gen.p0.p1(ptr addrspace(1) %p1)

  %p3 = call ptr addrspace(3) @llvm.nvvm.ptr.gen.to.shared.p3.p0(ptr %p2)
  %p4 = call ptr @llvm.nvvm.ptr.shared.to.gen.p0.p3(ptr addrspace(3) %p3)

  %p5 = call ptr addrspace(4) @llvm.nvvm.ptr.gen.to.constant.p4.p0(ptr %p4)
  %p6 = call ptr @llvm.nvvm.ptr.constant.to.gen.p0.p4(ptr addrspace(4) %p5)

  %p7 = call ptr addrspace(5) @llvm.nvvm.ptr.gen.to.local.p5.p0(ptr %p6)
  %p8 = call ptr @llvm.nvvm.ptr.local.to.gen.p0.p5(ptr addrspace(5) %p7)

  %p9 = call ptr addrspace(101) @llvm.nvvm.ptr.gen.to.param.p101.p0(ptr %p8)
  %p10 = call ptr @llvm.nvvm.ptr.param.to.gen.p0.p101(ptr addrspace(101) %p9)

  ret void
}

; CHECK-LABEL: @ldg
define void @ldg(ptr %p0, ptr addrspace(1) %p1) {
; CHECK: %1 = 加载 整数32, 指针 addrspace(1) %p1, 对齐 4, !invariant.load !0
; CHECK: %2 = 加载 指针, 指针 addrspace(1) %p1, 对齐 8, !invariant.load !0
; CHECK: %3 = 加载 单精度, 指针 addrspace(1) %p1, 对齐 16, !invariant.load !0

; CHECK: %4 = 地址空间转换 指针 %p0 到 指针 addrspace(1)
; CHECK: %5 = 加载 整数32, 指针 addrspace(1) %4, 对齐 4, !invariant.load !0
; CHECK: %6 = 地址空间转换 指针 %p0 到 指针 addrspace(1)
; CHECK: %7 = 加载 指针, 指针 addrspace(1) %6, 对齐 8, !invariant.load !0
; CHECK: %8 = 地址空间转换 指针 %p0 到 指针 addrspace(1)
; CHECK: %9 = 加载 单精度, 指针 addrspace(1) %8, 对齐 16, !invariant.load !0
;
  %v1 = call i32 @llvm.nvvm.ldg.global.i.i32.p1(ptr addrspace(1) %p1, i32 4)
  %v2 = call ptr @llvm.nvvm.ldg.global.p.p1(ptr addrspace(1) %p1, i32 8 )
  %v3 = call float @llvm.nvvm.ldg.global.f.f32.p1(ptr addrspace(1) %p1, i32 16)

  %v4 = call i32 @llvm.nvvm.ldg.global.i.i32.p0(ptr %p0, i32 4)
  %v5 = call ptr @llvm.nvvm.ldg.global.p.p0(ptr %p0, i32 8)
  %v6 = call float @llvm.nvvm.ldg.global.f.f32.p0(ptr %p0, i32 16)

  ret void
}

; CHECK-LABEL: @atomics
define i32 @atomics(ptr %p0, i32 %a, float %b, double %c) {
; CHECK: %1 = 原子读写 uinc_wrap 指针 %p0, 整数32 %a syncscope("device") monotonic
; CHECK: %2 = 原子读写 udec_wrap 指针 %p0, 整数32 %a syncscope("device") monotonic
; CHECK: %3 = 原子读写 fadd 指针 %p0, 单精度 %b syncscope("device") monotonic
; CHECK: %4 = 原子读写 fadd 指针 %p0, 双精度 %c syncscope("device") monotonic

  %r1 = call i32 @llvm.nvvm.atomic.load.inc.32.p0(ptr %p0, i32 %a)
  %r2 = call i32 @llvm.nvvm.atomic.load.dec.32.p0(ptr %p0, i32 %a)
  %r3 = call float @llvm.nvvm.atomic.load.add.f32.p0(ptr %p0, float %b)
  %r4 = call double @llvm.nvvm.atomic.load.add.f64.p0(ptr %p0, double %c)
  ret i32 %r2
}

; The scoped int_nvvm_atomic_*_gen_*_{cta,sys} intrinsics upgrade to atomicrmw /
; cmpxchg: "_cta" -> syncscope("block"), "_sys" -> system scope. Signed min/max
; (the old intrinsics carried no signedness and lowered signed).
;
; This covers the full cross product of removed intrinsics: every op, both scopes
; (cta/sys), and both element widths (i32/i64, plus f32/f64 for the float add).
; CHECK-LABEL: @atomics_scoped
define void @atomics_scoped(ptr %p, i32 %a, i64 %b, float %c, double %d) {
; CHECK: 原子读写 add 指针 %p, 整数32 %a syncscope("block") monotonic
  %add.i.cta.i32 = call i32 @llvm.nvvm.atomic.add.gen.i.cta.i32.p0(ptr %p, i32 %a)
; CHECK: 原子读写 add 指针 %p, 整数64 %b syncscope("block") monotonic
  %add.i.cta.i64 = call i64 @llvm.nvvm.atomic.add.gen.i.cta.i64.p0(ptr %p, i64 %b)
; CHECK: 原子读写 add 指针 %p, 整数32 %a monotonic
  %add.i.sys.i32 = call i32 @llvm.nvvm.atomic.add.gen.i.sys.i32.p0(ptr %p, i32 %a)
; CHECK: 原子读写 add 指针 %p, 整数64 %b monotonic
  %add.i.sys.i64 = call i64 @llvm.nvvm.atomic.add.gen.i.sys.i64.p0(ptr %p, i64 %b)
; CHECK: 原子读写 xchg 指针 %p, 整数32 %a syncscope("block") monotonic
  %exch.i.cta.i32 = call i32 @llvm.nvvm.atomic.exch.gen.i.cta.i32.p0(ptr %p, i32 %a)
; CHECK: 原子读写 xchg 指针 %p, 整数64 %b syncscope("block") monotonic
  %exch.i.cta.i64 = call i64 @llvm.nvvm.atomic.exch.gen.i.cta.i64.p0(ptr %p, i64 %b)
; CHECK: 原子读写 xchg 指针 %p, 整数32 %a monotonic
  %exch.i.sys.i32 = call i32 @llvm.nvvm.atomic.exch.gen.i.sys.i32.p0(ptr %p, i32 %a)
; CHECK: 原子读写 xchg 指针 %p, 整数64 %b monotonic
  %exch.i.sys.i64 = call i64 @llvm.nvvm.atomic.exch.gen.i.sys.i64.p0(ptr %p, i64 %b)
; CHECK: 原子读写 max 指针 %p, 整数32 %a syncscope("block") monotonic
  %max.i.cta.i32 = call i32 @llvm.nvvm.atomic.max.gen.i.cta.i32.p0(ptr %p, i32 %a)
; CHECK: 原子读写 max 指针 %p, 整数64 %b syncscope("block") monotonic
  %max.i.cta.i64 = call i64 @llvm.nvvm.atomic.max.gen.i.cta.i64.p0(ptr %p, i64 %b)
; CHECK: 原子读写 max 指针 %p, 整数32 %a monotonic
  %max.i.sys.i32 = call i32 @llvm.nvvm.atomic.max.gen.i.sys.i32.p0(ptr %p, i32 %a)
; CHECK: 原子读写 max 指针 %p, 整数64 %b monotonic
  %max.i.sys.i64 = call i64 @llvm.nvvm.atomic.max.gen.i.sys.i64.p0(ptr %p, i64 %b)
; CHECK: 原子读写 min 指针 %p, 整数32 %a syncscope("block") monotonic
  %min.i.cta.i32 = call i32 @llvm.nvvm.atomic.min.gen.i.cta.i32.p0(ptr %p, i32 %a)
; CHECK: 原子读写 min 指针 %p, 整数64 %b syncscope("block") monotonic
  %min.i.cta.i64 = call i64 @llvm.nvvm.atomic.min.gen.i.cta.i64.p0(ptr %p, i64 %b)
; CHECK: 原子读写 min 指针 %p, 整数32 %a monotonic
  %min.i.sys.i32 = call i32 @llvm.nvvm.atomic.min.gen.i.sys.i32.p0(ptr %p, i32 %a)
; CHECK: 原子读写 min 指针 %p, 整数64 %b monotonic
  %min.i.sys.i64 = call i64 @llvm.nvvm.atomic.min.gen.i.sys.i64.p0(ptr %p, i64 %b)
; CHECK: 原子读写 uinc_wrap 指针 %p, 整数32 %a syncscope("block") monotonic
  %inc.i.cta.i32 = call i32 @llvm.nvvm.atomic.inc.gen.i.cta.i32.p0(ptr %p, i32 %a)
; CHECK: 原子读写 uinc_wrap 指针 %p, 整数64 %b syncscope("block") monotonic
  %inc.i.cta.i64 = call i64 @llvm.nvvm.atomic.inc.gen.i.cta.i64.p0(ptr %p, i64 %b)
; CHECK: 原子读写 uinc_wrap 指针 %p, 整数32 %a monotonic
  %inc.i.sys.i32 = call i32 @llvm.nvvm.atomic.inc.gen.i.sys.i32.p0(ptr %p, i32 %a)
; CHECK: 原子读写 uinc_wrap 指针 %p, 整数64 %b monotonic
  %inc.i.sys.i64 = call i64 @llvm.nvvm.atomic.inc.gen.i.sys.i64.p0(ptr %p, i64 %b)
; CHECK: 原子读写 udec_wrap 指针 %p, 整数32 %a syncscope("block") monotonic
  %dec.i.cta.i32 = call i32 @llvm.nvvm.atomic.dec.gen.i.cta.i32.p0(ptr %p, i32 %a)
; CHECK: 原子读写 udec_wrap 指针 %p, 整数64 %b syncscope("block") monotonic
  %dec.i.cta.i64 = call i64 @llvm.nvvm.atomic.dec.gen.i.cta.i64.p0(ptr %p, i64 %b)
; CHECK: 原子读写 udec_wrap 指针 %p, 整数32 %a monotonic
  %dec.i.sys.i32 = call i32 @llvm.nvvm.atomic.dec.gen.i.sys.i32.p0(ptr %p, i32 %a)
; CHECK: 原子读写 udec_wrap 指针 %p, 整数64 %b monotonic
  %dec.i.sys.i64 = call i64 @llvm.nvvm.atomic.dec.gen.i.sys.i64.p0(ptr %p, i64 %b)
; CHECK: 原子读写 and 指针 %p, 整数32 %a syncscope("block") monotonic
  %and.i.cta.i32 = call i32 @llvm.nvvm.atomic.and.gen.i.cta.i32.p0(ptr %p, i32 %a)
; CHECK: 原子读写 and 指针 %p, 整数64 %b syncscope("block") monotonic
  %and.i.cta.i64 = call i64 @llvm.nvvm.atomic.and.gen.i.cta.i64.p0(ptr %p, i64 %b)
; CHECK: 原子读写 and 指针 %p, 整数32 %a monotonic
  %and.i.sys.i32 = call i32 @llvm.nvvm.atomic.and.gen.i.sys.i32.p0(ptr %p, i32 %a)
; CHECK: 原子读写 and 指针 %p, 整数64 %b monotonic
  %and.i.sys.i64 = call i64 @llvm.nvvm.atomic.and.gen.i.sys.i64.p0(ptr %p, i64 %b)
; CHECK: 原子读写 or 指针 %p, 整数32 %a syncscope("block") monotonic
  %or.i.cta.i32 = call i32 @llvm.nvvm.atomic.or.gen.i.cta.i32.p0(ptr %p, i32 %a)
; CHECK: 原子读写 or 指针 %p, 整数64 %b syncscope("block") monotonic
  %or.i.cta.i64 = call i64 @llvm.nvvm.atomic.or.gen.i.cta.i64.p0(ptr %p, i64 %b)
; CHECK: 原子读写 or 指针 %p, 整数32 %a monotonic
  %or.i.sys.i32 = call i32 @llvm.nvvm.atomic.or.gen.i.sys.i32.p0(ptr %p, i32 %a)
; CHECK: 原子读写 or 指针 %p, 整数64 %b monotonic
  %or.i.sys.i64 = call i64 @llvm.nvvm.atomic.or.gen.i.sys.i64.p0(ptr %p, i64 %b)
; CHECK: 原子读写 xor 指针 %p, 整数32 %a syncscope("block") monotonic
  %xor.i.cta.i32 = call i32 @llvm.nvvm.atomic.xor.gen.i.cta.i32.p0(ptr %p, i32 %a)
; CHECK: 原子读写 xor 指针 %p, 整数64 %b syncscope("block") monotonic
  %xor.i.cta.i64 = call i64 @llvm.nvvm.atomic.xor.gen.i.cta.i64.p0(ptr %p, i64 %b)
; CHECK: 原子读写 xor 指针 %p, 整数32 %a monotonic
  %xor.i.sys.i32 = call i32 @llvm.nvvm.atomic.xor.gen.i.sys.i32.p0(ptr %p, i32 %a)
; CHECK: 原子读写 xor 指针 %p, 整数64 %b monotonic
  %xor.i.sys.i64 = call i64 @llvm.nvvm.atomic.xor.gen.i.sys.i64.p0(ptr %p, i64 %b)
; CHECK: [[CAS_cta_i32:%.*]] = 比较交换 指针 %p, 整数32 %a, 整数32 %a syncscope("block") monotonic monotonic
; CHECK: 提取值 { 整数32, 整数1 } [[CAS_cta_i32]], 0
  %cas.i.cta.i32 = call i32 @llvm.nvvm.atomic.cas.gen.i.cta.i32.p0(ptr %p, i32 %a, i32 %a)
; CHECK: [[CAS_cta_i64:%.*]] = 比较交换 指针 %p, 整数64 %b, 整数64 %b syncscope("block") monotonic monotonic
; CHECK: 提取值 { 整数64, 整数1 } [[CAS_cta_i64]], 0
  %cas.i.cta.i64 = call i64 @llvm.nvvm.atomic.cas.gen.i.cta.i64.p0(ptr %p, i64 %b, i64 %b)
; CHECK: [[CAS_sys_i32:%.*]] = 比较交换 指针 %p, 整数32 %a, 整数32 %a monotonic monotonic
; CHECK: 提取值 { 整数32, 整数1 } [[CAS_sys_i32]], 0
  %cas.i.sys.i32 = call i32 @llvm.nvvm.atomic.cas.gen.i.sys.i32.p0(ptr %p, i32 %a, i32 %a)
; CHECK: [[CAS_sys_i64:%.*]] = 比较交换 指针 %p, 整数64 %b, 整数64 %b monotonic monotonic
; CHECK: 提取值 { 整数64, 整数1 } [[CAS_sys_i64]], 0
  %cas.i.sys.i64 = call i64 @llvm.nvvm.atomic.cas.gen.i.sys.i64.p0(ptr %p, i64 %b, i64 %b)
; CHECK: 原子读写 fadd 指针 %p, 单精度 %c syncscope("block") monotonic
  %add.f.cta.f32 = call float @llvm.nvvm.atomic.add.gen.f.cta.f32.p0(ptr %p, float %c)
; CHECK: 原子读写 fadd 指针 %p, 双精度 %d syncscope("block") monotonic
  %add.f.cta.f64 = call double @llvm.nvvm.atomic.add.gen.f.cta.f64.p0(ptr %p, double %d)
; CHECK: 原子读写 fadd 指针 %p, 单精度 %c monotonic
  %add.f.sys.f32 = call float @llvm.nvvm.atomic.add.gen.f.sys.f32.p0(ptr %p, float %c)
; CHECK: 原子读写 fadd 指针 %p, 双精度 %d monotonic
  %add.f.sys.f64 = call double @llvm.nvvm.atomic.add.gen.f.sys.f64.p0(ptr %p, double %d)
  ret void
}

; CHECK-LABEL: @nvvm_shared_cluster_intrinsics
define void @nvvm_shared_cluster_intrinsics(ptr addrspace(3) %p0, i32 %offset) {
; CHECK: %r = 调用 指针 addrspace(7) @llvm.nvvm.mapa.shared.cluster(指针 addrspace(3) %p0, 整数32 %offset)
  %r = call ptr addrspace(3) @llvm.nvvm.mapa.shared.cluster(ptr addrspace(3) %p0, i32 %offset)
  ret void
}

; CHECK-LABEL: @nvvm_cp_async_bulk_intrinsics
define void @nvvm_cp_async_bulk_intrinsics(ptr addrspace(3) %dst, ptr addrspace(3) %bar, ptr addrspace(1) %src, ptr addrspace(3) %src_shared, i32 %size) {
; CHECK: 调用 空类型 @llvm.nvvm.cp.async.bulk.global.to.shared.cluster(指针 addrspace(7) %1, 指针 addrspace(3) %bar, 指针 addrspace(1) %src, 整数32 %size, 整数16 0, 整数64 0, 整数1 假, 整数1 假)
; CHECK: 调用 空类型 @llvm.nvvm.cp.async.bulk.shared.cta.to.cluster(指针 addrspace(7) %2, 指针 addrspace(3) %bar, 指针 addrspace(3) %src_shared, 整数32 %size)
  call void @llvm.nvvm.cp.async.bulk.global.to.shared.cluster(ptr addrspace(3) %dst, ptr addrspace(3) %bar, ptr addrspace(1) %src, i32 %size, i16 0, i64 0, i1 false, i1 false)
  call void @llvm.nvvm.cp.async.bulk.shared.cta.to.cluster(ptr addrspace(3) %dst, ptr addrspace(3) %bar, ptr addrspace(3) %src_shared, i32 %size)
  ret void
}

; CHECK-LABEL: @nvvm_cp_async_bulk_tensor_g2s_im2col
define void @nvvm_cp_async_bulk_tensor_g2s_im2col(ptr addrspace(3) %d, ptr addrspace(3) %bar, ptr %tmap, i32 %d0, i32 %d1, i32 %d2, i32 %d3, i32 %d4, i16 %im2col0, i16 %im2col1, i16 %im2col2, i16 %mc, i64 %ch) {
; CHECK: 调用 空类型 @llvm.nvvm.cp.async.bulk.tensor.g2s.im2col.3d(指针 addrspace(7) %1, 指针 addrspace(3) %bar, 指针 %tmap, 整数32 %d0, 整数32 %d1, 整数32 %d2, 整数16 %im2col0, 整数16 0, 整数64 0, 整数1 假, 整数1 假, 整数32 0)
; CHECK: 调用 空类型 @llvm.nvvm.cp.async.bulk.tensor.g2s.im2col.4d(指针 addrspace(7) %2, 指针 addrspace(3) %bar, 指针 %tmap, 整数32 %d0, 整数32 %d1, 整数32 %d2, 整数32 %d3, 整数16 %im2col0, 整数16 %im2col1, 整数16 0, 整数64 0, 整数1 假, 整数1 假, 整数32 0)
; CHECK: 调用 空类型 @llvm.nvvm.cp.async.bulk.tensor.g2s.im2col.5d(指针 addrspace(7) %3, 指针 addrspace(3) %bar, 指针 %tmap, 整数32 %d0, 整数32 %d1, 整数32 %d2, 整数32 %d3, 整数32 %d4, 整数16 %im2col0, 整数16 %im2col1, 整数16 %im2col2, 整数16 0, 整数64 0, 整数1 假, 整数1 假, 整数32 0)
  call void @llvm.nvvm.cp.async.bulk.tensor.g2s.im2col.3d(ptr addrspace(3) %d, ptr addrspace(3) %bar, ptr %tmap, i32 %d0, i32 %d1, i32 %d2, i16 %im2col0, i16 0, i64 0, i1 0, i1 0)
  call void @llvm.nvvm.cp.async.bulk.tensor.g2s.im2col.4d(ptr addrspace(3) %d, ptr addrspace(3) %bar, ptr %tmap, i32 %d0, i32 %d1, i32 %d2, i32 %d3, i16 %im2col0, i16 %im2col1, i16 0, i64 0, i1 0, i1 0)
  call void @llvm.nvvm.cp.async.bulk.tensor.g2s.im2col.5d(ptr addrspace(3) %d, ptr addrspace(3) %bar, ptr %tmap, i32 %d0, i32 %d1, i32 %d2, i32 %d3, i32 %d4, i16 %im2col0, i16 %im2col1, i16 %im2col2, i16 0, i64 0, i1 0, i1 0)
  ret void
}

; CHECK-LABEL: @nvvm_cp_async_bulk_tensor_g2s_tile
define void @nvvm_cp_async_bulk_tensor_g2s_tile(ptr addrspace(3) %d, ptr addrspace(3) %bar, ptr %tmap, i32 %d0, i32 %d1, i32 %d2, i32 %d3, i32 %d4, i16 %mc, i64 %ch) {
; CHECK: 调用 空类型 @llvm.nvvm.cp.async.bulk.tensor.g2s.tile.1d(指针 addrspace(7) %1, 指针 addrspace(3) %bar, 指针 %tmap, 整数32 %d0, 整数16 0, 整数64 0, 整数1 假, 整数1 假, 整数32 0)
; CHECK: 调用 空类型 @llvm.nvvm.cp.async.bulk.tensor.g2s.tile.2d(指针 addrspace(7) %2, 指针 addrspace(3) %bar, 指针 %tmap, 整数32 %d0, 整数32 %d1, 整数16 0, 整数64 0, 整数1 假, 整数1 假, 整数32 0)
; CHECK: 调用 空类型 @llvm.nvvm.cp.async.bulk.tensor.g2s.tile.3d(指针 addrspace(7) %3, 指针 addrspace(3) %bar, 指针 %tmap, 整数32 %d0, 整数32 %d1, 整数32 %d2, 整数16 0, 整数64 0, 整数1 假, 整数1 假, 整数32 0)
; CHECK: 调用 空类型 @llvm.nvvm.cp.async.bulk.tensor.g2s.tile.4d(指针 addrspace(7) %4, 指针 addrspace(3) %bar, 指针 %tmap, 整数32 %d0, 整数32 %d1, 整数32 %d2, 整数32 %d3, 整数16 0, 整数64 0, 整数1 假, 整数1 假, 整数32 0)
; CHECK: 调用 空类型 @llvm.nvvm.cp.async.bulk.tensor.g2s.tile.5d(指针 addrspace(7) %5, 指针 addrspace(3) %bar, 指针 %tmap, 整数32 %d0, 整数32 %d1, 整数32 %d2, 整数32 %d3, 整数32 %d4, 整数16 0, 整数64 0, 整数1 假, 整数1 假, 整数32 0)
  call void @llvm.nvvm.cp.async.bulk.tensor.g2s.tile.1d(ptr addrspace(3) %d, ptr addrspace(3) %bar, ptr %tmap, i32 %d0, i16 0, i64 0, i1 0, i1 0)
  call void @llvm.nvvm.cp.async.bulk.tensor.g2s.tile.2d(ptr addrspace(3) %d, ptr addrspace(3) %bar, ptr %tmap, i32 %d0, i32 %d1, i16 0, i64 0, i1 0, i1 0)
  call void @llvm.nvvm.cp.async.bulk.tensor.g2s.tile.3d(ptr addrspace(3) %d, ptr addrspace(3) %bar, ptr %tmap, i32 %d0, i32 %d1, i32 %d2, i16 0, i64 0, i1 0, i1 0)
  call void @llvm.nvvm.cp.async.bulk.tensor.g2s.tile.4d(ptr addrspace(3) %d, ptr addrspace(3) %bar, ptr %tmap, i32 %d0, i32 %d1, i32 %d2, i32 %d3, i16 0, i64 0, i1 0, i1 0)
  call void @llvm.nvvm.cp.async.bulk.tensor.g2s.tile.5d(ptr addrspace(3) %d, ptr addrspace(3) %bar, ptr %tmap, i32 %d0, i32 %d1, i32 %d2, i32 %d3, i32 %d4, i16 0, i64 0, i1 0, i1 0)
  ret void
}

define void @cta_barriers(i32 %x, i32 %y, i32 %z) {
; CHECK: 调用 空类型 @llvm.nvvm.barrier.cta.sync.aligned.all(整数32 0)
; CHECK: 调用 空类型 @llvm.nvvm.barrier.cta.sync.aligned.all(整数32 %x)
; CHECK: 调用 空类型 @llvm.nvvm.barrier.cta.sync.aligned.all(整数32 %x)
; CHECK: 调用 空类型 @llvm.nvvm.barrier.cta.sync.aligned.count(整数32 %x, 整数32 %y)
; CHECK: 调用 空类型 @llvm.nvvm.barrier.cta.sync.all(整数32 %x)
; CHECK: 调用 空类型 @llvm.nvvm.barrier.cta.sync.count(整数32 %x, 整数32 %y)

; CHECK: %1 = 整数比较 ne 整数32 %z, 0
; CHECK: %2 = 调用 整数32 @llvm.nvvm.barrier.cta.red.popc.aligned.all(整数32 0, 整数1 %1)
; CHECK: %3 = 整数比较 ne 整数32 %z, 0
; CHECK: %4 = 调用 整数1 @llvm.nvvm.barrier.cta.red.and.aligned.all(整数32 0, 整数1 %3)
; CHECK: %5 = 零扩展 整数1 %4 到 整数32
; CHECK: %6 = 整数比较 ne 整数32 %z, 0
; CHECK: %7 = 调用 整数1 @llvm.nvvm.barrier.cta.red.or.aligned.all(整数32 0, 整数1 %6)
; CHECK: %8 = 零扩展 整数1 %7 到 整数32

  call void @llvm.nvvm.barrier0()
  call void @llvm.nvvm.barrier.n(i32 %x)
  call void @llvm.nvvm.bar.sync(i32 %x)
  call void @llvm.nvvm.barrier(i32 %x, i32 %y)
  call void @llvm.nvvm.barrier.sync(i32 %x)
  call void @llvm.nvvm.barrier.sync.cnt(i32 %x, i32 %y)

  %r1 = call i32 @llvm.nvvm.barrier0.popc(i32 %z)
  %r2 = call i32 @llvm.nvvm.barrier0.and(i32 %z)
  %r3 = call i32 @llvm.nvvm.barrier0.or(i32 %z)
  ret void
}

define void @nvvm_ex2_approx(float %a, double %b, half %c, <2 x half> %d) {
; CHECK: 调用 单精度 @llvm.nvvm.ex2.approx.f32(单精度 %a)
; CHECK: 调用 双精度 @llvm.nvvm.ex2.approx.f64(双精度 %b)
; CHECK: 调用 <2 个 半精度> @llvm.nvvm.ex2.approx.v2f16(<2 个 半精度> %d)
; CHECK: 调用 单精度 @llvm.nvvm.ex2.approx.ftz.f32(单精度 %a)
  %r1 = call float @llvm.nvvm.ex2.approx.f(float %a)
  %r2 = call double @llvm.nvvm.ex2.approx.d(double %b)
  %r3 = call <2 x half> @llvm.nvvm.ex2.approx.f16x2(<2 x half> %d)
  %r4 = call float @llvm.nvvm.ex2.approx.ftz.f(float %a)
  ret void
}
