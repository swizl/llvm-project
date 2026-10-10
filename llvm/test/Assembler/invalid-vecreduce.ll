; RUN: not opt -S < %s 2>&1 | FileCheck %s

; CHECK: intrinsic return type (vector element of overload type 0) expected 双精度 (overload type 0 is <2 个 双精度>), but got 单精度
; CHECK-NEXT: 声明 单精度 @llvm.vector.reduce.fadd.f32.f64.v2f64(双精度, <2 个 双精度>)
declare float @llvm.vector.reduce.fadd.f32.f64.v2f64(double %acc, <2 x double> %in)

; CHECK: intrinsic argument 0 type (vector element of overload type 0) expected 双精度 (overload type 0 is <2 个 双精度>), but got 单精度
; CHECK-NEXT: 声明 双精度 @llvm.vector.reduce.fadd.f64.f32.v2f64(单精度, <2 个 双精度>)
declare double @llvm.vector.reduce.fadd.f64.f32.v2f64(float %acc, <2 x double> %in)

; CHECK: intrinsic return type (vector element of overload type 0) expected 双精度 (overload type 0 is <2 个 双精度>), but got <2 个 双精度>
; CHECK-NEXT: 声明 <2 个 双精度> @llvm.vector.reduce.fadd.v2f64.f64.v2f64(双精度, <2 个 双精度>)
declare <2 x double> @llvm.vector.reduce.fadd.v2f64.f64.v2f64(double %acc, <2 x double> %in)

; CHECK: intrinsic argument 0 type (vector element of overload type 0) expected 双精度 (overload type 0 is <2 个 双精度>), but got <2 个 双精度>
; CHECK-NEXT: 声明 双精度 @llvm.vector.reduce.fadd.f64.v2f64.v2f64(<2 个 双精度>, <2 个 双精度>)
declare double @llvm.vector.reduce.fadd.f64.v2f64.v2f64(<2 x double> %acc, <2 x double> %in)
