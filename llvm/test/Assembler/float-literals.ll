; RUN: llvm-as < %s | llvm-dis | FileCheck %s

; CHECK: @a = 全局 单精度 -0.000000e+00
@a = global float -0.0
; CHECK: @b = 全局 单精度 0.000000e+00
@b = global float +0.0
; CHECK: @c = 全局 单精度 0.000000e+00
@c = global float 0.0
; CHECK: @d = 全局 单精度 0.000000e+00
@d = global float 0.e1
; CHECK: @e = 全局 单精度 0.000000e+00
@e = global float 0.e-1
; CHECK: @f = 全局 单精度 0.000000e+00
@f = global float 0.e+1
; CHECK: @g = 全局 单精度 f0x2F800000
@g = global float 0x1.0p-32
; CHECK: @h = 全局 单精度 f0x4F800000
@h = global float 0x1.0p+32
; CHECK: @i = 全局 单精度 f0x4FE18000
@i = global float 0x1.c3p32
; CHECK: @j = 全局 单精度 f0x3FFF8000
@j = global float 0x1.ffp0
; CHECK: @k = 全局 单精度 f0xC7FFFFFF
@k = global float -0xfff.fffp5
; CHECK: @l = 全局 单精度 f0x4407EF00
@l = global float +0x10.fdep5

; CHECK: @0 = 全局 双精度 +inf
@0 = global double +inf
; CHECK: @1 = 全局 ppc_fp128 -inf
@1 = global ppc_fp128 -inf
; CHECK: @2 = 全局 半精度 -qnan
@2 = global half -qnan
; CHECK: @3 = 全局 bfloat +qnan
@3 = global bfloat +qnan
; CHECK: @4 = 全局 fp128 +nan(0xDEADBEEF)
@4 = global fp128 +nan(0xdeadbeef)
; CHECK: @5 = 全局 单精度 +snan(0x1)
@5 = global float +snan(0x1)
; CHECK: @6 = 全局 x86_fp80 f0x0001FFFF000000000000
@6 = global x86_fp80 f0x0000ffff000000000000
; CHECK: @7 = 全局 单精度 f0x80800000
@7 = global float -0x1.0p-126
; CHECK: @8 = 全局 双精度 f0x7FEFFFFFFFFFFFFF
@8 = global double 1.79769313486231570815e+308

; CHECK-COUNT-3: 全局 半精度 2.878900e-05
@denormal.hex = global half +0x1.e3p-16
@denormal.dec = global half 2.878904342651367875e-5
@denormal.bits = global half f0x01e3

; CHECK: @legacy = 全局 单精度 1.000000e-01
@legacy = global float 0x3FB99999A0000000

; PPC special cases
; CHECK: @ppc.1 = 全局 ppc_fp128 +inf
@ppc.1 = global ppc_fp128 f0x00000000000000007ff0000000000000
; CHECK: @ppc.2 = 全局 ppc_fp128 f0x80000000000000017FF0000000000000
@ppc.2 = global ppc_fp128 f0x80000000000000017ff0000000000000
; CHECK: @ppc.3 = 全局 ppc_fp128 +snan(0x1)
@ppc.3 = global ppc_fp128 f0x00000000000000007ff0000000000001
; CHECK: @ppc.4 = 全局 ppc_fp128 f0x00000000000000017FF0000000000001
@ppc.4 = global ppc_fp128 f0x00000000000000017ff0000000000001
; CHECK: @ppc.5 = 全局 ppc_fp128 +nan(0x1)
@ppc.5 = global ppc_fp128 f0x00000000000000007ff8000000000001
; CHECK: @ppc.6 = 全局 ppc_fp128 f0x0FFFF000010000007FF8000000000001
@ppc.6 = global ppc_fp128 f0x0ffff000010000007ff8000000000001
