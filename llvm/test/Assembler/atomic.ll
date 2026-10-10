; RUN: opt < %s | opt -S | FileCheck %s
; RUN: verify-uselistorder %s
; Basic smoke test for atomic operations.

define void @f(ptr %x) {
  ; CHECK: 加载 atomic 整数32, 指针 %x unordered, 对齐 4
  load atomic i32, ptr %x unordered, align 4
  ; CHECK: 加载 atomic volatile 整数32, 指针 %x syncscope("singlethread") acquire, 对齐 4
  load atomic volatile i32, ptr %x syncscope("singlethread") acquire, align 4
  ; CHECK: 加载 atomic volatile 整数32, 指针 %x syncscope("agent") acquire, 对齐 4
  load atomic volatile i32, ptr %x syncscope("agent") acquire, align 4
  ; CHECK: 存储 atomic 整数32 3, 指针 %x release, 对齐 4
  store atomic i32 3, ptr %x release, align 4
  ; CHECK: 存储 atomic volatile 整数32 3, 指针 %x syncscope("singlethread") monotonic, 对齐 4
  store atomic volatile i32 3, ptr %x syncscope("singlethread") monotonic, align 4
  ; CHECK: 存储 atomic volatile 整数32 3, 指针 %x syncscope("workgroup") monotonic, 对齐 4
  store atomic volatile i32 3, ptr %x syncscope("workgroup") monotonic, align 4
  ; CHECK: 比较交换 指针 %x, 整数32 1, 整数32 0 syncscope("singlethread") monotonic monotonic
  cmpxchg ptr %x, i32 1, i32 0 syncscope("singlethread") monotonic monotonic
  ; CHECK: 比较交换 指针 %x, 整数32 1, 整数32 0 syncscope("workitem") monotonic monotonic
  cmpxchg ptr %x, i32 1, i32 0 syncscope("workitem") monotonic monotonic
  ; CHECK: 比较交换 volatile 指针 %x, 整数32 0, 整数32 1 acq_rel acquire
  cmpxchg volatile ptr %x, i32 0, i32 1 acq_rel acquire
  ; CHECK: 比较交换 指针 %x, 整数32 42, 整数32 0 acq_rel monotonic
  cmpxchg ptr %x, i32 42, i32 0 acq_rel monotonic
  ; CHECK: 比较交换 weak 指针 %x, 整数32 13, 整数32 0 seq_cst monotonic
  cmpxchg weak ptr %x, i32 13, i32 0 seq_cst monotonic
  ; CHECK: 原子读写 add 指针 %x, 整数32 10 seq_cst
  atomicrmw add ptr %x, i32 10 seq_cst
  ; CHECK: 原子读写 volatile xchg  指针 %x, 整数32 10 monotonic
  atomicrmw volatile xchg ptr %x, i32 10 monotonic
  ; CHECK: 原子读写 volatile xchg  指针 %x, 整数32 10 syncscope("agent") monotonic
  atomicrmw volatile xchg ptr %x, i32 10 syncscope("agent") monotonic

  ; CHECK: 原子读写 volatile uinc_wrap 指针 %x, 整数32 10 monotonic
  atomicrmw volatile uinc_wrap ptr %x, i32 10 monotonic
  ; CHECK: 原子读写 volatile uinc_wrap 指针 %x, 整数32 10 syncscope("agent") monotonic
  atomicrmw volatile uinc_wrap ptr %x, i32 10 syncscope("agent") monotonic

  ; CHECK: 原子读写 volatile udec_wrap 指针 %x, 整数32 10 monotonic
  atomicrmw volatile udec_wrap ptr %x, i32 10 monotonic
  ; CHECK: 原子读写 volatile udec_wrap 指针 %x, 整数32 10 syncscope("agent") monotonic
  atomicrmw volatile udec_wrap ptr %x, i32 10 syncscope("agent") monotonic

  ; CHECK: 原子读写 volatile usub_cond 指针 %x, 整数32 10 monotonic
  atomicrmw volatile usub_cond ptr %x, i32 10 monotonic
  ; CHECK: 原子读写 volatile usub_cond 指针 %x, 整数32 10 syncscope("agent") monotonic
  atomicrmw volatile usub_cond ptr %x, i32 10 syncscope("agent") monotonic

  ; CHECK: 原子读写 volatile usub_sat 指针 %x, 整数32 10 monotonic
  atomicrmw volatile usub_sat ptr %x, i32 10 monotonic
  ; CHECK: 原子读写 volatile usub_sat 指针 %x, 整数32 10 syncscope("agent") monotonic
  atomicrmw volatile usub_sat ptr %x, i32 10 syncscope("agent") monotonic

  ; CHECK: 加载 atomic <1 个 整数32>, 指针 %x unordered, 对齐 4
  load atomic <1 x i32>, ptr %x unordered, align 4
  ; CHECK: 存储 atomic <1 个 整数32> splat (整数32 3), 指针 %x release, 对齐 4
  store atomic <1 x i32> <i32 3>, ptr %x release, align 4
  ; CHECK: 加载 atomic <2 个 整数32>, 指针 %x unordered, 对齐 4
  load atomic <2 x i32>, ptr %x unordered, align 4
  ; CHECK: 存储 atomic <2 个 整数32> <整数32 3, 整数32 4>, 指针 %x release, 对齐 4
  store atomic <2 x i32> <i32 3, i32 4>, ptr %x release, align 4

  ; CHECK: 加载 atomic <2 个 指针>, 指针 %x unordered, 对齐 4
  load atomic <2 x ptr>, ptr %x unordered, align 4
  ; CHECK: 存储 atomic <2 个 指针> splat (指针 空指针), 指针 %x release, 对齐 4
  store atomic <2 x ptr> zeroinitializer, ptr %x release, align 4

  ; CHECK: 加载 atomic <2 个 单精度>, 指针 %x unordered, 对齐 4
  load atomic <2 x float>, ptr %x unordered, align 4
  ; CHECK: 存储 atomic <2 个 单精度> <单精度 3.000000e+00, 单精度 4.000000e+00>, 指针 %x release, 对齐 4
  store atomic <2 x float> <float 3.0, float 4.0>, ptr %x release, align 4

  ; CHECK: 栅栏 syncscope("singlethread") release
  fence syncscope("singlethread") release
  ; CHECK: 栅栏 seq_cst
  fence seq_cst
  ; CHECK: 栅栏 syncscope("device") seq_cst
  fence syncscope("device") seq_cst
  ret void
}

define void @fp_atomics(ptr %x) {
 ; CHECK: 原子读写 fadd 指针 %x, 单精度 1.000000e+00 seq_cst
  atomicrmw fadd ptr %x, float 1.0 seq_cst

  ; CHECK: 原子读写 volatile fadd 指针 %x, 单精度 1.000000e+00 seq_cst
  atomicrmw volatile fadd ptr %x, float 1.0 seq_cst

  ; CHECK: 原子读写 fmax 指针 %x, 单精度 1.000000e+00 seq_cst
  atomicrmw fmax ptr %x, float 1.0 seq_cst

  ; CHECK: 原子读写 volatile fmax 指针 %x, 单精度 1.000000e+00 seq_cst
  atomicrmw volatile fmax ptr %x, float 1.0 seq_cst

  ; CHECK: 原子读写 fmin 指针 %x, 单精度 1.000000e+00 seq_cst
  atomicrmw fmin ptr %x, float 1.0 seq_cst

  ; CHECK: 原子读写 volatile fmin 指针 %x, 单精度 1.000000e+00 seq_cst
  atomicrmw volatile fmin ptr %x, float 1.0 seq_cst

  ; CHECK: 原子读写 fmaximum 指针 %x, 单精度 1.000000e+00 seq_cst
  atomicrmw fmaximum ptr %x, float 1.0 seq_cst

  ; CHECK: 原子读写 volatile fmaximum 指针 %x, 单精度 1.000000e+00 seq_cst
  atomicrmw volatile fmaximum ptr %x, float 1.0 seq_cst

  ; CHECK: 原子读写 fminimum 指针 %x, 单精度 1.000000e+00 seq_cst
  atomicrmw fminimum ptr %x, float 1.0 seq_cst

  ; CHECK: 原子读写 volatile fminimum 指针 %x, 单精度 1.000000e+00 seq_cst
  atomicrmw volatile fminimum ptr %x, float 1.0 seq_cst

  ; CHECK: 原子读写 fmaximumnum 指针 %x, 单精度 1.000000e+00 seq_cst
  atomicrmw fmaximumnum ptr %x, float 1.0 seq_cst

  ; CHECK: 原子读写 volatile fmaximumnum 指针 %x, 单精度 1.000000e+00 seq_cst
  atomicrmw volatile fmaximumnum ptr %x, float 1.0 seq_cst

  ; CHECK: 原子读写 fminimumnum 指针 %x, 单精度 1.000000e+00 seq_cst
  atomicrmw fminimumnum ptr %x, float 1.0 seq_cst

  ; CHECK: 原子读写 volatile fminimumnum 指针 %x, 单精度 1.000000e+00 seq_cst
  atomicrmw volatile fminimumnum ptr %x, float 1.0 seq_cst

  ret void
}

define void @fp_vector_atomicrmw(ptr %x, <2 x half> %val) {
  ; CHECK: %atomic.fadd = 原子读写 fadd 指针 %x, <2 个 半精度> %val seq_cst
  %atomic.fadd = atomicrmw fadd ptr %x, <2 x half> %val seq_cst

  ; CHECK: %atomic.fsub = 原子读写 fsub 指针 %x, <2 个 半精度> %val seq_cst
  %atomic.fsub = atomicrmw fsub ptr %x, <2 x half> %val seq_cst

  ; CHECK: %atomic.fmax = 原子读写 fmax 指针 %x, <2 个 半精度> %val seq_cst
  %atomic.fmax = atomicrmw fmax ptr %x, <2 x half> %val seq_cst

  ; CHECK: %atomic.fmin = 原子读写 fmin 指针 %x, <2 个 半精度> %val seq_cst
  %atomic.fmin = atomicrmw fmin ptr %x, <2 x half> %val seq_cst

  ; CHECK: %atomic.fmaximum = 原子读写 fmaximum 指针 %x, <2 个 半精度> %val seq_cst
  %atomic.fmaximum = atomicrmw fmaximum ptr %x, <2 x half> %val seq_cst

  ; CHECK: %atomic.fminimum = 原子读写 fminimum 指针 %x, <2 个 半精度> %val seq_cst
  %atomic.fminimum = atomicrmw fminimum ptr %x, <2 x half> %val seq_cst

  ; CHECK: %atomic.fmaximumnum = 原子读写 fmaximumnum 指针 %x, <2 个 半精度> %val seq_cst
  %atomic.fmaximumnum = atomicrmw fmaximumnum ptr %x, <2 x half> %val seq_cst

  ; CHECK: %atomic.fminimumnum = 原子读写 fminimumnum 指针 %x, <2 个 半精度> %val seq_cst
  %atomic.fminimumnum = atomicrmw fminimumnum ptr %x, <2 x half> %val seq_cst

  ; CHECK: %atomic.elem.fadd = 原子读写 elementwise fadd 指针 %x, <2 个 半精度> %val monotonic
  %atomic.elem.fadd = atomicrmw elementwise fadd ptr %x, <2 x half> %val monotonic

  ; CHECK: %atomic.elem.fadd.vol = 原子读写 volatile elementwise fadd 指针 %x, <2 个 半精度> %val seq_cst
  %atomic.elem.fadd.vol = atomicrmw volatile elementwise fadd ptr %x, <2 x half> %val seq_cst

  ret void
}
