; RUN: llvm-as < %s | llvm-dis | FileCheck %s

; All fields with integer syntax
define void @nofpclass_1023(float nofpclass(1023) %x) {
; CHECK-LABEL: 定义 {{[^@]+}}@nofpclass_1023
; CHECK-SAME: (单精度 nofpclass(all) [[X:%.*]]) {
; CHECK-NEXT:    返回 空类型
;
  ret void
}

; --------------------------------------------------------------------
; Single field, integer syntax
; --------------------------------------------------------------------

define void @nofpclass_1(float nofpclass(1) %x) {
; CHECK-LABEL: 定义 {{[^@]+}}@nofpclass_1
; CHECK-SAME: (单精度 nofpclass(snan) [[X:%.*]]) {
; CHECK-NEXT:    返回 空类型
;
  ret void
}

define void @nofpclass_2(float nofpclass(2) %x) {
; CHECK-LABEL: 定义 {{[^@]+}}@nofpclass_2
; CHECK-SAME: (单精度 nofpclass(qnan) [[X:%.*]]) {
; CHECK-NEXT:    返回 空类型
;
  ret void
}

define void @nofpclass_3(float nofpclass(4) %x) {
; CHECK-LABEL: 定义 {{[^@]+}}@nofpclass_3
; CHECK-SAME: (单精度 nofpclass(ninf) [[X:%.*]]) {
; CHECK-NEXT:    返回 空类型
;
  ret void
}

define void @nofpclass_8(float nofpclass(8) %x) {
; CHECK-LABEL: 定义 {{[^@]+}}@nofpclass_8
; CHECK-SAME: (单精度 nofpclass(nnorm) [[X:%.*]]) {
; CHECK-NEXT:    返回 空类型
;
  ret void
}

define void @nofpclass_16(float nofpclass(16) %x) {
; CHECK-LABEL: 定义 {{[^@]+}}@nofpclass_16
; CHECK-SAME: (单精度 nofpclass(nsub) [[X:%.*]]) {
; CHECK-NEXT:    返回 空类型
;
  ret void
}

define void @nofpclass_32(float nofpclass(32) %x) {
; CHECK-LABEL: 定义 {{[^@]+}}@nofpclass_32
; CHECK-SAME: (单精度 nofpclass(nzero) [[X:%.*]]) {
; CHECK-NEXT:    返回 空类型
;
  ret void
}

define void @nofpclass_64(float nofpclass(64) %x) {
; CHECK-LABEL: 定义 {{[^@]+}}@nofpclass_64
; CHECK-SAME: (单精度 nofpclass(pzero) [[X:%.*]]) {
; CHECK-NEXT:    返回 空类型
;
  ret void
}

define void @nofpclass_128(float nofpclass(128) %x) {
; CHECK-LABEL: 定义 {{[^@]+}}@nofpclass_128
; CHECK-SAME: (单精度 nofpclass(psub) [[X:%.*]]) {
; CHECK-NEXT:    返回 空类型
;
  ret void
}

define void @nofpclass_256(float nofpclass(256) %x) {
; CHECK-LABEL: 定义 {{[^@]+}}@nofpclass_256
; CHECK-SAME: (单精度 nofpclass(pnorm) [[X:%.*]]) {
; CHECK-NEXT:    返回 空类型
;
  ret void
}

define void @nofpclass_512(float nofpclass(512) %x) {
; CHECK-LABEL: 定义 {{[^@]+}}@nofpclass_512
; CHECK-SAME: (单精度 nofpclass(pinf) [[X:%.*]]) {
; CHECK-NEXT:    返回 空类型
;
  ret void
}

define void @nofpclass_8_extra_space(float nofpclass(  8   ) %x) {
; CHECK-LABEL: 定义 {{[^@]+}}@nofpclass_8_extra_space
; CHECK-SAME: (单精度 nofpclass(nnorm) [[X:%.*]]) {
; CHECK-NEXT:    返回 空类型
;
  ret void
}

; --------------------------------------------------------------------
; Canonical single field names
; --------------------------------------------------------------------

define void @nofpclass_snan(float nofpclass(snan) %x) {
; CHECK-LABEL: 定义 {{[^@]+}}@nofpclass_snan
; CHECK-SAME: (单精度 nofpclass(snan) [[X:%.*]]) {
; CHECK-NEXT:    返回 空类型
;
  ret void
}

define void @nofpclass_qnan(float nofpclass(qnan) %x) {
; CHECK-LABEL: 定义 {{[^@]+}}@nofpclass_qnan
; CHECK-SAME: (单精度 nofpclass(qnan) [[X:%.*]]) {
; CHECK-NEXT:    返回 空类型
;
  ret void
}

define void @nofpclass_ninf(float nofpclass(ninf) %x) {
; CHECK-LABEL: 定义 {{[^@]+}}@nofpclass_ninf
; CHECK-SAME: (单精度 nofpclass(ninf) [[X:%.*]]) {
; CHECK-NEXT:    返回 空类型
;
  ret void
}

define void @nofpclass_nnorm(float nofpclass(nnorm) %x) {
; CHECK-LABEL: 定义 {{[^@]+}}@nofpclass_nnorm
; CHECK-SAME: (单精度 nofpclass(nnorm) [[X:%.*]]) {
; CHECK-NEXT:    返回 空类型
;
  ret void
}

define void @nofpclass_nsub(float nofpclass(nsub) %x) {
; CHECK-LABEL: 定义 {{[^@]+}}@nofpclass_nsub
; CHECK-SAME: (单精度 nofpclass(nsub) [[X:%.*]]) {
; CHECK-NEXT:    返回 空类型
;
  ret void
}

define void @nofpclass_nzero(float nofpclass(nzero) %x) {
; CHECK-LABEL: 定义 {{[^@]+}}@nofpclass_nzero
; CHECK-SAME: (单精度 nofpclass(nzero) [[X:%.*]]) {
; CHECK-NEXT:    返回 空类型
;
  ret void
}

define void @nofpclass_pzero(float nofpclass(pzero) %x) {
; CHECK-LABEL: 定义 {{[^@]+}}@nofpclass_pzero
; CHECK-SAME: (单精度 nofpclass(pzero) [[X:%.*]]) {
; CHECK-NEXT:    返回 空类型
;
  ret void
}

define void @nofpclass_psub(float nofpclass(psub) %x) {
; CHECK-LABEL: 定义 {{[^@]+}}@nofpclass_psub
; CHECK-SAME: (单精度 nofpclass(psub) [[X:%.*]]) {
; CHECK-NEXT:    返回 空类型
;
  ret void
}

define void @nofpclass_pnorm(float nofpclass(pnorm) %x) {
; CHECK-LABEL: 定义 {{[^@]+}}@nofpclass_pnorm
; CHECK-SAME: (单精度 nofpclass(pnorm) [[X:%.*]]) {
; CHECK-NEXT:    返回 空类型
;
  ret void
}

define void @nofpclass_pinf(float nofpclass(pinf) %x) {
; CHECK-LABEL: 定义 {{[^@]+}}@nofpclass_pinf
; CHECK-SAME: (单精度 nofpclass(pinf) [[X:%.*]]) {
; CHECK-NEXT:    返回 空类型
;
  ret void
}

; --------------------------------------------------------------------
; Pretty printed pairs
; --------------------------------------------------------------------

define void @nofpclass_nan(float nofpclass(nan) %x) {
; CHECK-LABEL: 定义 {{[^@]+}}@nofpclass_nan
; CHECK-SAME: (单精度 nofpclass(nan) [[X:%.*]]) {
; CHECK-NEXT:    返回 空类型
;
  ret void
}

define void @nofpclass_inf(float nofpclass(inf) %x) {
; CHECK-LABEL: 定义 {{[^@]+}}@nofpclass_inf
; CHECK-SAME: (单精度 nofpclass(inf) [[X:%.*]]) {
; CHECK-NEXT:    返回 空类型
;
  ret void
}

define void @nofpclass_norm(float nofpclass(norm) %x) {
; CHECK-LABEL: 定义 {{[^@]+}}@nofpclass_norm
; CHECK-SAME: (单精度 nofpclass(norm) [[X:%.*]]) {
; CHECK-NEXT:    返回 空类型
;
  ret void
}

define void @nofpclass_sub(float nofpclass(sub) %x) {
; CHECK-LABEL: 定义 {{[^@]+}}@nofpclass_sub
; CHECK-SAME: (单精度 nofpclass(sub) [[X:%.*]]) {
; CHECK-NEXT:    返回 空类型
;
  ret void
}

define void @nofpclass_zero(float nofpclass(zero) %x) {
; CHECK-LABEL: 定义 {{[^@]+}}@nofpclass_zero
; CHECK-SAME: (单精度 nofpclass(zero) [[X:%.*]]) {
; CHECK-NEXT:    返回 空类型
;
  ret void
}

; --------------------------------------------------------------------
; Special helper names
; --------------------------------------------------------------------

define void @nofpclass_all(float nofpclass(all) %x) {
; CHECK-LABEL: 定义 {{[^@]+}}@nofpclass_all
; CHECK-SAME: (单精度 nofpclass(all) [[X:%.*]]) {
; CHECK-NEXT:    返回 空类型
;
  ret void
}

; --------------------------------------------------------------------
; Return position
; --------------------------------------------------------------------

define nofpclass(nan) float @return_nan(float %arg) {
; CHECK-LABEL: 定义 {{[^@]+}}@return_nan
; CHECK-SAME: (单精度 [[ARG:%.*]]) {
; CHECK-NEXT:    返回 单精度 [[ARG]]
;
  ret float %arg
}

; --------------------------------------------------------------------
; Callsite positions
; --------------------------------------------------------------------

declare float @func(float)

define float @callsite_nofpclass_arg(float %arg) {
; CHECK-LABEL: 定义 {{[^@]+}}@callsite_nofpclass_arg
; CHECK-SAME: (单精度 [[ARG:%.*]]) {
; CHECK-NEXT:    [[CALL:%.*]] = 调用 单精度 @func(单精度 nofpclass(nan) [[ARG]])
; CHECK-NEXT:    返回 单精度 [[CALL]]
;
  %call = call float @func(float nofpclass(nan) %arg)
  ret float %call
}

define float @callsite_nofpclass_return(float %arg) {
; CHECK-LABEL: 定义 {{[^@]+}}@callsite_nofpclass_return
; CHECK-SAME: (单精度 [[ARG:%.*]]) {
; CHECK-NEXT:    [[CALL:%.*]] = 调用 nofpclass(nan) 单精度 @func(单精度 [[ARG]])
; CHECK-NEXT:    返回 单精度 [[CALL]]
;
  %call = call nofpclass(nan) float @func(float %arg)
  ret float %call
}

; --------------------------------------------------------------------
; Declaration
; --------------------------------------------------------------------

declare nofpclass(inf) float @declaration(float nofpclass(zero))

; --------------------------------------------------------------------
; Combinations of named values
; --------------------------------------------------------------------

define void @nofpclass_nan_inf(float nofpclass(nan inf) %x) {
; CHECK-LABEL: 定义 {{[^@]+}}@nofpclass_nan_inf
; CHECK-SAME: (单精度 nofpclass(nan inf) [[X:%.*]]) {
; CHECK-NEXT:    返回 空类型
;
  ret void
}

define void @nofpclass_inf_nan(float nofpclass(inf nan) %x) {
; CHECK-LABEL: 定义 {{[^@]+}}@nofpclass_inf_nan
; CHECK-SAME: (单精度 nofpclass(nan inf) [[X:%.*]]) {
; CHECK-NEXT:    返回 空类型
;
  ret void
}

define void @nofpclass_nan_qnan_snan(float nofpclass(nan qnan snan) %x) {
; CHECK-LABEL: 定义 {{[^@]+}}@nofpclass_nan_qnan_snan
; CHECK-SAME: (单精度 nofpclass(nan) [[X:%.*]]) {
; CHECK-NEXT:    返回 空类型
;
  ret void
}

define void @nofpclass_snan_qnan_nan(float nofpclass(snan qnan nan) %x) {
; CHECK-LABEL: 定义 {{[^@]+}}@nofpclass_snan_qnan_nan
; CHECK-SAME: (单精度 nofpclass(nan) [[X:%.*]]) {
; CHECK-NEXT:    返回 空类型
;
  ret void
}

define void @nofpclass_all_pairs_named(float nofpclass(nan inf norm sub zero) %x) {
; CHECK-LABEL: 定义 {{[^@]+}}@nofpclass_all_pairs_named
; CHECK-SAME: (单精度 nofpclass(all) [[X:%.*]]) {
; CHECK-NEXT:    返回 空类型
;
  ret void
}

define void @nofpclass_all_pairs_named_reverse(float nofpclass(zero sub norm inf nan) %x) {
; CHECK-LABEL: 定义 {{[^@]+}}@nofpclass_all_pairs_named_reverse
; CHECK-SAME: (单精度 nofpclass(all) [[X:%.*]]) {
; CHECK-NEXT:    返回 空类型
;
  ret void
}

define void @nofpclass_all_pairs_named_shuffle0(float nofpclass(sub nan norm zero inf) %x) {
; CHECK-LABEL: 定义 {{[^@]+}}@nofpclass_all_pairs_named_shuffle0
; CHECK-SAME: (单精度 nofpclass(all) [[X:%.*]]) {
; CHECK-NEXT:    返回 空类型
;
  ret void
}

define void @nofpclass_all_fields_named(float nofpclass(snan qnan ninf pinf nnorm pnorm nsub psub nzero pzero) %x) {
; CHECK-LABEL: 定义 {{[^@]+}}@nofpclass_all_fields_named
; CHECK-SAME: (单精度 nofpclass(all) [[X:%.*]]) {
; CHECK-NEXT:    返回 空类型
;
  ret void
}

define void @nofpclass_all_fields_named_reverse(float nofpclass(pzero nzero psub nsub pnorm nnorm pinf ninf qnan snan) %x) {
; CHECK-LABEL: 定义 {{[^@]+}}@nofpclass_all_fields_named_reverse
; CHECK-SAME: (单精度 nofpclass(all) [[X:%.*]]) {
; CHECK-NEXT:    返回 空类型
;
  ret void
}

define void @nofpclass_snan_ninf(float nofpclass(snan ninf) %x) {
; CHECK-LABEL: 定义 {{[^@]+}}@nofpclass_snan_ninf
; CHECK-SAME: (单精度 nofpclass(snan ninf) [[X:%.*]]) {
; CHECK-NEXT:    返回 空类型
;
  ret void
}

define void @nofpclass_ninf_snan(float nofpclass(ninf  snan) %x) {
; CHECK-LABEL: 定义 {{[^@]+}}@nofpclass_ninf_snan
; CHECK-SAME: (单精度 nofpclass(snan ninf) [[X:%.*]]) {
; CHECK-NEXT:    返回 空类型
;
  ret void
}

; --------------------------------------------------------------------
; Supported IR types
; --------------------------------------------------------------------

; Vector FP
define void @nofpclass_nan_inf_v2f16(<2 x half> nofpclass(nan inf) %x) {
; CHECK-LABEL: 定义 {{[^@]+}}@nofpclass_nan_inf_v2f16
; CHECK-SAME: (<2 个 半精度> nofpclass(nan inf) [[X:%.*]]) {
; CHECK-NEXT:    返回 空类型
;
  ret void
}

; Scalable Vector FP
define void @nofpclass_nan_inf_scalable_v2f16(<vscale x 2 x half> nofpclass(nan inf) %x) {
; CHECK-LABEL: 定义 {{[^@]+}}@nofpclass_nan_inf_scalable_v2f16
; CHECK-SAME: (<vscale x 2 个 半精度> nofpclass(nan inf) [[X:%.*]]) {
; CHECK-NEXT:    返回 空类型
;
  ret void
}

; Array of scalar FP
define void @nofpclass_nan_inf_a4f64([4 x double] nofpclass(nan inf) %x) {
; CHECK-LABEL: 定义 {{[^@]+}}@nofpclass_nan_inf_a4f64
; CHECK-SAME: ([4 个 双精度] nofpclass(nan inf) [[X:%.*]]) {
; CHECK-NEXT:    返回 空类型
;
  ret void
}

; Array of vector FP
define void @nofpclass_nan_inf_a4v2f16([4 x <2 x half>] nofpclass(nan inf) %x) {
; CHECK-LABEL: 定义 {{[^@]+}}@nofpclass_nan_inf_a4v2f16
; CHECK-SAME: ([4 个 <2 个 半精度>] nofpclass(nan inf) [[X:%.*]]) {
; CHECK-NEXT:    返回 空类型
;
  ret void
}

; Array of array of scalar FP
define void @nofpclass_nan_inf_a8a4f32([8 x [4 x float]] nofpclass(nan inf) %x) {
; CHECK-LABEL: 定义 {{[^@]+}}@nofpclass_nan_inf_a8a4f32
; CHECK-SAME: ([8 个 [4 个 单精度]] nofpclass(nan inf) [[X:%.*]]) {
; CHECK-NEXT:    返回 空类型
;
  ret void
}

; Array of array of vector FP
define void @nofpclass_nan_inf_a8a4v2f32([8 x [4 x <2 x float>]] nofpclass(nan inf) %x) {
; CHECK-LABEL: 定义 {{[^@]+}}@nofpclass_nan_inf_a8a4v2f32
; CHECK-SAME: ([8 个 [4 个 <2 个 单精度>]] nofpclass(nan inf) [[X:%.*]]) {
; CHECK-NEXT:    返回 空类型
;
  ret void
}
