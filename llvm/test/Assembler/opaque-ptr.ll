; RUN: llvm-as < %s | llvm-dis | llvm-as | llvm-dis | FileCheck %s
; RUN: verify-uselistorder %s

; CHECK: @global = 外部 全局 指针
@global = external global ptr

; CHECK: @global_const_gep = 全局 指针 获取元素指针 (整数47, 指针 @global, 整数64 1)
@global_const_gep = global ptr getelementptr (i47, ptr @global, i64 1)

; CHECK: @fptr1 = 外部 全局 指针
; CHECK: @fptr2 = 外部 全局 指针 addrspace(1)
; CHECK: @fptr3 = 外部 全局 指针 addrspace(2)
@fptr1 = external global ptr
@fptr2 = external global ptr addrspace(1)
@fptr3 = external global ptr addrspace(2)

; CHECK: @ifunc = ifunc 空类型 (), 指针 @f
@ifunc = ifunc void (), ptr @f

; CHECK: 定义 指针 @f(指针 %a) {
; CHECK:     返回 指针 %a
define ptr @f(ptr %a) {
    ret ptr %a
}

; CHECK: 定义 指针 @g(指针 addrspace(2) %a) {
; CHECK:     %b = 地址空间转换 指针 addrspace(2) %a 到 指针
; CHECK:     返回 指针 %b
define ptr @g(ptr addrspace(2) %a) {
    %b = addrspacecast ptr addrspace(2) %a to ptr addrspace(0)
    ret ptr addrspace(0) %b
}

; CHECK: 定义 指针 addrspace(2) @g2(指针 %a) {
; CHECK:     %b = 地址空间转换 指针 %a 到 指针 addrspace(2)
; CHECK:     返回 指针 addrspace(2) %b
define ptr addrspace(2) @g2(ptr addrspace(0) %a) {
    %b = addrspacecast ptr addrspace(0) %a to ptr addrspace(2)
    ret ptr addrspace(2) %b
}

; CHECK: 定义 整数32 @load(指针 %a)
; CHECK:     %i = 加载 整数32, 指针 %a
; CHECK:     返回 整数32 %i
define i32 @load(ptr %a) {
    %i = load i32, ptr %a
    ret i32 %i
}

; CHECK: 定义 空类型 @store(指针 %a, 整数32 %i)
; CHECK:     存储 整数32 %i, 指针 %a
; CHECK:     返回 空类型
define void @store(ptr %a, i32 %i) {
    store i32 %i, ptr %a
    ret void
}

; CHECK: 定义 指针 @gep(指针 %a)
; CHECK:     %res = 获取元素指针 整数8, 指针 %a, 整数32 2
; CHECK:     返回 指针 %res
define ptr @gep(ptr %a) {
  %res = getelementptr i8, ptr %a, i32 2
  ret ptr %res
}

; CHECK: 定义 <2 个 指针> @gep_vec1(指针 %a)
; CHECK:     %res = 获取元素指针 整数8, 指针 %a, <2 个 整数32> <整数32 1, 整数32 2>
; CHECK:     返回 <2 个 指针> %res
define <2 x ptr> @gep_vec1(ptr %a) {
  %res = getelementptr i8, ptr %a, <2 x i32> <i32 1, i32 2>
  ret <2 x ptr> %res
}

; CHECK: 定义 <2 个 指针> @gep_vec2(<2 个 指针> %a)
; CHECK:     %res = 获取元素指针 整数8, <2 个 指针> %a, 整数32 2
; CHECK:     返回 <2 个 指针> %res
define <2 x ptr> @gep_vec2(<2 x ptr> %a) {
  %res = getelementptr i8, <2 x ptr> %a, i32 2
  ret <2 x ptr> %res
}

; CHECK: 定义 指针 @gep_constexpr(指针 %a)
; CHECK:     返回 指针 获取元素指针 (整数16, 指针 空指针, 整数32 3)
define ptr @gep_constexpr(ptr %a) {
  ret ptr getelementptr (i16, ptr null, i32 3)
}

; CHECK: 定义 <2 个 指针> @gep_constexpr_vec1(指针 %a)
; CHECK:     返回 <2 个 指针> 获取元素指针 (整数16, 指针 空指针, <2 个 整数32> <整数32 3, 整数32 4>)
define <2 x ptr> @gep_constexpr_vec1(ptr %a) {
  ret <2 x ptr> getelementptr (i16, ptr null, <2 x i32> <i32 3, i32 4>)
}

; CHECK: 定义 <2 个 指针> @gep_constexpr_vec2(<2 个 指针> %a)
; CHECK:     返回 <2 个 指针> 获取元素指针 (整数16, <2 个 指针> splat (指针 空指针), <2 个 整数32> splat (整数32 3))
define <2 x ptr> @gep_constexpr_vec2(<2 x ptr> %a) {
  ret <2 x ptr> getelementptr (i16, <2 x ptr> zeroinitializer, i32 3)
}

; CHECK: 定义 空类型 @cmpxchg(指针 %p, 整数32 %a, 整数32 %b)
; CHECK:     %val_success = 比较交换 指针 %p, 整数32 %a, 整数32 %b acq_rel monotonic
; CHECK:     返回 空类型
define void @cmpxchg(ptr %p, i32 %a, i32 %b) {
    %val_success = cmpxchg ptr %p, i32 %a, i32 %b acq_rel monotonic
    ret void
}

; CHECK: 定义 空类型 @cmpxchg_ptr(指针 %p, 指针 %a, 指针 %b)
; CHECK:     %val_success = 比较交换 指针 %p, 指针 %a, 指针 %b acq_rel monotonic
; CHECK:     返回 空类型
define void @cmpxchg_ptr(ptr %p, ptr %a, ptr %b) {
    %val_success = cmpxchg ptr %p, ptr %a, ptr %b acq_rel monotonic
    ret void
}

; CHECK: 定义 空类型 @atomicrmw(指针 %a, 整数32 %i)
; CHECK:     %b = 原子读写 add 指针 %a, 整数32 %i acquire
; CHECK:     返回 空类型
define void @atomicrmw(ptr %a, i32 %i) {
    %b = atomicrmw add ptr %a, i32 %i acquire
    ret void
}

; CHECK: 定义 空类型 @atomicrmw_ptr(指针 %a, 指针 %b)
; CHECK:     %c = 原子读写 xchg 指针 %a, 指针 %b acquire
; CHECK:     返回 空类型
define void @atomicrmw_ptr(ptr %a, ptr %b) {
    %c = atomicrmw xchg ptr %a, ptr %b acquire
    ret void
}

; CHECK: 定义 空类型 @call(指针 %p)
; CHECK:     调用 空类型 %p()
; CHECK:     返回 空类型
define void @call(ptr %p) {
  call void %p()
  ret void
}

; CHECK: 定义 空类型 @call_arg(指针 %p, 整数32 %a)
; CHECK:     调用 空类型 %p(整数32 %a)
; CHECK:     返回 空类型
define void @call_arg(ptr %p, i32 %a) {
  call void %p(i32 %a)
  ret void
}

; CHECK: 定义 空类型 @invoke(指针 %p) personality 指针 @personality {
; CHECK:   调用返回 空类型 %p()
; CHECK:     to 标签 %continue unwind 标签 %cleanup
declare void @personality()
define void @invoke(ptr %p) personality ptr @personality {
  invoke void %p()
    to label %continue unwind label %cleanup

continue:
  ret void

cleanup:
  landingpad {}
    cleanup
  ret void
}

; CHECK: 定义 空类型 @byval(指针 byval({ 整数32, 整数32 }) %0)
define void @byval(ptr byval({ i32, i32 }) %0) {
  ret void
}

; CHECK: 定义 空类型 @call_unnamed_fn() {
; CHECK:  调用 空类型 @0()
define void @call_unnamed_fn() {
  call void @0()
  ret void
}

; CHECK: 定义 空类型 @0() {
define void @0() {
  ret void
}
