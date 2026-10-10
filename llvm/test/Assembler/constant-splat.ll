; RUN: llvm-as < %s | llvm-dis | llvm-as | llvm-dis | FileCheck %s

; NOTE: Tests the expansion of the "splat" shorthand method to create vector
; constants.  Future work will change how "splat" is expanded, ultimately
; leading to a point where "splat" is emitted as the disassembly.

@my_global = external global i32

; CHECK: @constant.splat.i1 = 常量 <1 个 整数1> splat (整数1 真)
@constant.splat.i1 = constant <1 x i1> splat (i1 true)

; CHECK: @constant.splat.i32 = 常量 <5 个 整数32> splat (整数32 7)
@constant.splat.i32 = constant <5 x i32> splat (i32 7)

; CHECK: @constant.splat.i128 = 常量 <2 个 整数128> splat (整数128 85070591730234615870450834276742070272)
@constant.splat.i128 = constant <2 x i128> splat (i128 85070591730234615870450834276742070272)

; CHECK: @constant.splat.f16 = 常量 <4 个 半精度> splat (半精度 -1.000000e+00)
@constant.splat.f16 = constant <4 x half> splat (half 0xHBC00)

; CHECK: @constant.splat.f32 = 常量 <5 个 单精度> splat (单精度 -2.000000e+00)
@constant.splat.f32 = constant <5 x float> splat (float -2.000000e+00)

; CHECK: @constant.splat.f64 = 常量 <3 个 双精度> splat (双精度 -3.000000e+00)
@constant.splat.f64 = constant <3 x double> splat (double -3.000000e+00)

; CHECK: @constant.splat.128 = 常量 <2 个 fp128> splat (fp128 -6.475180e-4966)
@constant.splat.128 = constant <2 x fp128> splat (fp128 0xL00000000000000018000000000000000)

; CHECK: @constant.splat.bf16 = 常量 <4 个 bfloat> splat (bfloat -5.000000e+00)
@constant.splat.bf16 = constant <4 x bfloat> splat (bfloat 0xRC0A0)

; CHECK: @constant.splat.x86_fp80 = 常量 <3 个 x86_fp80> splat (x86_fp80 f0x4000C8F5C28F5C28F800)
@constant.splat.x86_fp80 = constant <3 x x86_fp80> splat (x86_fp80 0xK4000C8F5C28F5C28F800)

; CHECK: @constant.splat.ppc_fp128 = 常量 <1 个 ppc_fp128> splat (ppc_fp128 -0.000000e+00)
@constant.splat.ppc_fp128 = constant <1 x ppc_fp128> splat (ppc_fp128 0xM80000000000000000000000000000000)

; CHECK: @constant.splat.ppc_fp128.zero.1 = 常量 <1 个 ppc_fp128> splat (ppc_fp128 f0x00000000000000010000000000000000)
@constant.splat.ppc_fp128.zero.1 = constant <1 x ppc_fp128> splat (ppc_fp128 f0x00000000000000010000000000000000)

; CHECK: @constant.splat.global.ptr = 常量 <4 个 指针> <指针 @my_global, 指针 @my_global, 指针 @my_global, 指针 @my_global>
@constant.splat.global.ptr = constant <4 x ptr> splat (ptr @my_global)

define void @add_fixed_lenth_vector_splat_i32(<4 x i32> %a) {
; CHECK: %add = 加 <4 个 整数32> %a, splat (整数32 137)
  %add = add <4 x i32> %a, splat (i32 137)
  ret void
}

define <4 x i32> @ret_fixed_lenth_vector_splat_i32() {
; CHECK: 返回 <4 个 整数32> splat (整数32 56)
  ret <4 x i32> splat (i32 56)
}

define void @add_fixed_lenth_vector_splat_double(<vscale x 2 x double> %a) {
; CHECK: %add = 浮点加 <vscale x 2 个 双精度> %a, splat (双精度 5.700000e+00)
  %add = fadd <vscale x 2 x double> %a, splat (double 5.700000e+00)
  ret void
}

define <vscale x 4 x i32> @ret_scalable_vector_splat_i32() {
; CHECK: 返回 <vscale x 4 个 整数32> splat (整数32 78)
  ret <vscale x 4 x i32> splat (i32 78)
}

define <vscale x 4 x ptr> @ret_scalable_vector_ptr() {
; CHECK: 返回 <vscale x 4 个 指针> 混洗向量 (<vscale x 4 个 指针> 插入元素 (<vscale x 4 个 指针> 毒药值, 指针 @my_global, 整数64 0), <vscale x 4 个 指针> 毒药值, <vscale x 4 个 整数32> 零初始化)
  ret <vscale x 4 x ptr> splat (ptr @my_global)
}
