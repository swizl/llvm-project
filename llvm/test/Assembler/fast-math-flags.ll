; RUN: llvm-as < %s | llvm-dis | FileCheck -strict-whitespace %s
; RUN: opt -S < %s | FileCheck -strict-whitespace %s
; RUN: verify-uselistorder %s

@addr   = external global i64
@select = external global i1
@vec    = external global <3 x float>
@arr    = external global [3 x float]
@int    = external global i32
@ivec   = external global <3 x i32>

declare float @foo(float)

define float @none(float %x, float %y) {
entry:
; CHECK:  %vec = 加载 <3 个 单精度>, 指针 @vec
  %vec    = load <3 x float>, ptr @vec
; CHECK:  %select = 加载 整数1, 指针 @select
  %select = load i1, ptr @select
; CHECK:  %arr = 加载 [3 个 单精度], 指针 @arr
  %arr    = load [3 x float], ptr @arr
; CHECK:  %scalable = 加载 <vscale x 3 个 单精度>, 指针 @vec
  %scalable = load <vscale x 3 x float>, ptr @vec
; CHECK: %int = 加载 整数32, 指针 @int
  %int = load i32, ptr @int
; CHECK: %ivec = 加载 <3 个 整数32>, 指针 @ivec
  %ivec = load <3 x i32>, ptr @ivec

; CHECK:  %a = 浮点加 单精度 %x, %y
  %a = fadd float %x, %y
; CHECK:  %a_vec = 浮点加 <3 个 单精度> %vec, %vec
  %a_vec = fadd <3 x float> %vec, %vec
; CHECK:  %b = 浮点减 单精度 %x, %y
  %b = fsub float %x, %y
; CHECK:  %b_vec = 浮点减 <3 个 单精度> %vec, %vec
  %b_vec = fsub <3 x float> %vec, %vec
; CHECK:  %c = 浮点乘 单精度 %x, %y
  %c = fmul float %x, %y
; CHECK:  %c_vec = 浮点乘 <3 个 单精度> %vec, %vec
  %c_vec = fmul <3 x float> %vec, %vec
; CHECK:  %d = 浮点除 单精度 %x, %y
  %d = fdiv float %x, %y
; CHECK:  %d_vec = 浮点除 <3 个 单精度> %vec, %vec
  %d_vec = fdiv <3 x float> %vec, %vec
; CHECK:  %e = 浮点取余 单精度 %x, %y
  %e = frem float %x, %y
; CHECK:  %e_vec = 浮点取余 <3 个 单精度> %vec, %vec
  %e_vec = frem <3 x float> %vec, %vec
; CHECK:  %f = 取反 单精度 %x
  %f = fneg float %x
; CHECK:  %f_vec = 取反 <3 个 单精度> %vec
  %f_vec = fneg <3 x float> %vec
; CHECK: %g = 浮点扩展 单精度 %x 到 双精度
  %g = fpext float %x to double
; CHECK: %g_vec = 浮点扩展 <3 个 单精度> %vec 到 <3 个 双精度>
  %g_vec = fpext <3 x float> %vec to <3 x double>
; CHECK: %g_scalable = 浮点扩展 <vscale x 3 个 单精度> %scalable 到 <vscale x 3 个 双精度>
  %g_scalable = fpext <vscale x 3 x float> %scalable to <vscale x 3 x double>
; CHECK: %h = 浮点截断 单精度 %x 到 半精度
  %h = fptrunc float %x to half
; CHECK: %h_vec = 浮点截断 <3 个 单精度> %vec 到 <3 个 半精度>
  %h_vec = fptrunc <3 x float> %vec to <3 x half>
; CHECK: %h_scalable = 浮点截断 <vscale x 3 个 单精度> %scalable 到 <vscale x 3 个 半精度>
  %h_scalable = fptrunc <vscale x 3 x float> %scalable to <vscale x 3 x half>
; CHECK: %i = 无符号转浮点 整数32 %int 到 单精度
  %i = uitofp i32 %int to float
; CHECK: %i_vec = 无符号转浮点 <3 个 整数32> %ivec 到 <3 个 单精度>
  %i_vec = uitofp <3 x i32> %ivec to <3 x float>
; CHECK: %j = 有符号转浮点 整数32 %int 到 单精度
  %j = sitofp i32 %int to float
; CHECK: %j_vec = 有符号转浮点 <3 个 整数32> %ivec 到 <3 个 单精度>
  %j_vec = sitofp <3 x i32> %ivec to <3 x float>
; CHECK:  返回 单精度 %f
  ret  float %f
}

; CHECK: no_nan
define float @no_nan(float %x, float %y) {
entry:
; CHECK:  %vec = 加载 <3 个 单精度>, 指针 @vec
  %vec    = load <3 x float>, ptr @vec
; CHECK:  %select = 加载 整数1, 指针 @select
  %select = load i1, ptr @select
; CHECK:  %arr = 加载 [3 个 单精度], 指针 @arr
  %arr    = load [3 x float], ptr @arr
; CHECK:  %scalable = 加载 <vscale x 3 个 单精度>, 指针 @vec
  %scalable = load <vscale x 3 x float>, ptr @vec

; CHECK:  %a = 浮点加 nnan 单精度 %x, %y
  %a = fadd nnan float %x, %y
; CHECK:  %a_vec = 浮点加 nnan <3 个 单精度> %vec, %vec
  %a_vec = fadd nnan <3 x float> %vec, %vec
; CHECK:  %b = 浮点减 nnan 单精度 %x, %y
  %b = fsub nnan float %x, %y
; CHECK:  %b_vec = 浮点减 nnan <3 个 单精度> %vec, %vec
  %b_vec = fsub nnan <3 x float> %vec, %vec
; CHECK:  %c = 浮点乘 nnan 单精度 %x, %y
  %c = fmul nnan float %x, %y
; CHECK:  %c_vec = 浮点乘 nnan <3 个 单精度> %vec, %vec
  %c_vec = fmul nnan <3 x float> %vec, %vec
; CHECK:  %d = 浮点除 nnan 单精度 %x, %y
  %d = fdiv nnan float %x, %y
; CHECK:  %d_vec = 浮点除 nnan <3 个 单精度> %vec, %vec
  %d_vec = fdiv nnan <3 x float> %vec, %vec
; CHECK:  %e = 浮点取余 nnan 单精度 %x, %y
  %e = frem nnan float %x, %y
; CHECK:  %e_vec = 浮点取余 nnan <3 个 单精度> %vec, %vec
  %e_vec = frem nnan <3 x float> %vec, %vec
; CHECK:  %f = 取反 nnan 单精度 %x
  %f = fneg nnan float %x
; CHECK:  %f_vec = 取反 nnan <3 个 单精度> %vec
  %f_vec = fneg nnan <3 x float> %vec
; CHECK: %g = 浮点扩展 nnan 单精度 %x 到 双精度
  %g = fpext nnan float %x to double
; CHECK: %g_vec = 浮点扩展 nnan <3 个 单精度> %vec 到 <3 个 双精度>
  %g_vec = fpext nnan <3 x float> %vec to <3 x double>
; CHECK: %g_scalable = 浮点扩展 nnan <vscale x 3 个 单精度> %scalable 到 <vscale x 3 个 双精度>
  %g_scalable = fpext nnan <vscale x 3 x float> %scalable to <vscale x 3 x double>
; CHECK: %h = 浮点截断 nnan 单精度 %x 到 半精度
  %h = fptrunc nnan float %x to half
; CHECK: %h_vec = 浮点截断 nnan <3 个 单精度> %vec 到 <3 个 半精度>
  %h_vec = fptrunc nnan <3 x float> %vec to <3 x half>
; CHECK: %h_scalable = 浮点截断 nnan <vscale x 3 个 单精度> %scalable 到 <vscale x 3 个 半精度>
  %h_scalable = fptrunc nnan <vscale x 3 x float> %scalable to <vscale x 3 x half>
; CHECK:  返回 单精度 %f
  ret float %f
}

; CHECK: @contract(
define float @contract(float %x, float %y) {
entry:
; CHECK: %a = 浮点减 contract 单精度 %x, %y
  %a = fsub contract float %x, %y
; CHECK: %b = 浮点加 contract 单精度 %x, %y
  %b = fadd contract float %x, %y
; CHECK: %c = 浮点乘 contract 单精度 %a, %b
  %c = fmul contract float %a, %b
; CHECK: %d = 浮点扩展 contract 单精度 %x 到 双精度
  %d = fpext contract float %x to double
; CHECK: %e = 浮点截断 contract 单精度 %x 到 半精度
  %e = fptrunc contract float %x to half
  ret float %c
}

; CHECK: @reassoc(
define float @reassoc(float %x, float %y) {
; CHECK: %a = 浮点减 reassoc 单精度 %x, %y
  %a = fsub reassoc float %x, %y
; CHECK: %b = 浮点乘 reassoc 单精度 %x, %y
  %b = fmul reassoc float %x, %y
; CHECK: %c = 调用 reassoc 单精度 @foo(单精度 %b)
  %c = call reassoc float @foo(float %b)
; CHECK: %d = 浮点扩展 reassoc 单精度 %x 到 双精度
  %d = fpext reassoc float %x to double
; CHECK: %e = 浮点截断 reassoc 单精度 %x 到 半精度
  %e = fptrunc reassoc float %x to half
  ret float %c
}

; CHECK: @afn(
define float @afn(float %x, float %y) {
; CHECK: %a = 浮点除 afn 单精度 %x, %y
  %a = fdiv afn float %x, %y
; CHECK: %b = 浮点取余 afn 单精度 %x, %y
  %b = frem afn float %x, %y
; CHECK: %c = 调用 afn 单精度 @foo(单精度 %b)
  %c = call afn float @foo(float %b)
  ret float %c
}

; CHECK: no_nan_inf
define float @no_nan_inf(float %x, float %y) {
entry:
; CHECK:  %vec = 加载 <3 个 单精度>, 指针 @vec
  %vec    = load <3 x float>, ptr @vec
; CHECK:  %select = 加载 整数1, 指针 @select
  %select = load i1, ptr @select
; CHECK:  %arr = 加载 [3 个 单精度], 指针 @arr
  %arr    = load [3 x float], ptr @arr
; CHECK:  %scalable = 加载 <vscale x 3 个 单精度>, 指针 @vec
  %scalable = load <vscale x 3 x float>, ptr @vec

; CHECK:  %a = 浮点加 nnan ninf 单精度 %x, %y
  %a = fadd ninf nnan float %x, %y
; CHECK:  %a_vec = 浮点加 nnan <3 个 单精度> %vec, %vec
  %a_vec = fadd nnan <3 x float> %vec, %vec
; CHECK:  %b = 浮点减 nnan 单精度 %x, %y
  %b = fsub nnan float %x, %y
; CHECK:  %b_vec = 浮点减 nnan ninf <3 个 单精度> %vec, %vec
  %b_vec = fsub ninf nnan <3 x float> %vec, %vec
; CHECK:  %c = 浮点乘 nnan 单精度 %x, %y
  %c = fmul nnan float %x, %y
; CHECK:  %c_vec = 浮点乘 nnan <3 个 单精度> %vec, %vec
  %c_vec = fmul nnan <3 x float> %vec, %vec
; CHECK:  %d = 浮点除 nnan ninf 单精度 %x, %y
  %d = fdiv ninf nnan float %x, %y
; CHECK:  %d_vec = 浮点除 nnan <3 个 单精度> %vec, %vec
  %d_vec = fdiv nnan <3 x float> %vec, %vec
; CHECK:  %e = 浮点取余 nnan 单精度 %x, %y
  %e = frem nnan float %x, %y
; CHECK:  %e_vec = 浮点取余 nnan ninf <3 个 单精度> %vec, %vec
  %e_vec = frem ninf nnan <3 x float> %vec, %vec
; CHECK: %f = 浮点扩展 nnan ninf 单精度 %x 到 双精度
  %f = fpext ninf nnan float %x to double
; CHECK: %f_vec = 浮点扩展 nnan ninf <3 个 单精度> %vec 到 <3 个 双精度>
  %f_vec = fpext ninf nnan <3 x float> %vec to <3 x double>
; CHECK: %f_scalable = 浮点扩展 nnan ninf <vscale x 3 个 单精度> %scalable 到 <vscale x 3 个 双精度>
  %f_scalable = fpext ninf nnan <vscale x 3 x float> %scalable to <vscale x 3 x double>
; CHECK: %g = 浮点截断 nnan ninf 单精度 %x 到 半精度
  %g = fptrunc ninf nnan float %x to half
; CHECK: %g_vec = 浮点截断 nnan ninf <3 个 单精度> %vec 到 <3 个 半精度>
  %g_vec = fptrunc ninf nnan <3 x float> %vec to <3 x half>
; CHECK: %g_scalable = 浮点截断 nnan ninf <vscale x 3 个 单精度> %scalable 到 <vscale x 3 个 半精度>
  %g_scalable = fptrunc ninf nnan <vscale x 3 x float> %scalable to <vscale x 3 x half>
; CHECK:  返回 单精度 %e
  ret float %e
}

; CHECK: mixed_flags
define float @mixed_flags(float %x, float %y) {
entry:
; CHECK:  %vec = 加载 <3 个 单精度>, 指针 @vec
  %vec    = load <3 x float>, ptr @vec
; CHECK:  %select = 加载 整数1, 指针 @select
  %select = load i1, ptr @select
; CHECK:  %arr = 加载 [3 个 单精度], 指针 @arr
  %arr    = load [3 x float], ptr @arr
; CHECK:  %int = 加载 整数32, 指针 @int
  %int    = load i32, ptr @int
; CHECK: %ivec = 加载 <3 个 整数32>, 指针 @ivec
  %ivec   = load <3 x i32>, ptr @ivec

; CHECK:  %a = 浮点加 nnan ninf afn 单精度 %x, %y
  %a = fadd ninf nnan afn float %x, %y
; CHECK:  %a_vec = 浮点加 reassoc nnan <3 个 单精度> %vec, %vec
  %a_vec = fadd reassoc nnan <3 x float> %vec, %vec
; CHECK:  %b = 浮点减 fast 单精度 %x, %y
  %b = fsub nnan nsz fast float %x, %y
; CHECK:  %b_vec = 浮点减 nnan <3 个 单精度> %vec, %vec
  %b_vec = fsub nnan <3 x float> %vec, %vec
; CHECK:  %c = 浮点乘 fast 单精度 %x, %y
  %c = fmul nsz fast arcp float %x, %y
; CHECK:  %c_vec = 浮点乘 nsz <3 个 单精度> %vec, %vec
  %c_vec = fmul nsz <3 x float> %vec, %vec
; CHECK:  %d = 浮点除 nnan ninf arcp 单精度 %x, %y
  %d = fdiv arcp ninf nnan float %x, %y
; CHECK:  %d_vec = 浮点除 fast <3 个 单精度> %vec, %vec
  %d_vec = fdiv fast nnan arcp <3 x float> %vec, %vec
; CHECK:  %e = 浮点取余 nnan nsz 单精度 %x, %y
  %e = frem nnan nsz float %x, %y
; CHECK:  %e_vec = 浮点取余 nnan <3 个 单精度> %vec, %vec
  %e_vec = frem nnan <3 x float> %vec, %vec
; CHECK:  %f = 取反 nnan nsz 单精度 %x
  %f = fneg nnan nsz float %x
; CHECK:  %f_vec = 取反 fast <3 个 单精度> %vec
  %f_vec = fneg fast <3 x float> %vec
; CHECK: %g = 无符号转浮点 nsz nneg 整数32 %int 到 单精度
  %g = uitofp nsz nneg i32 %int to float
; CHECK: %g_vec = 无符号转浮点 nsz nneg <3 个 整数32> %ivec 到 <3 个 单精度>
  %g_vec = uitofp nsz nneg <3 x i32> %ivec to <3 x float>
; CHECK: %h = 有符号转浮点 nnan nsz 整数32 %int 到 单精度
  %h = sitofp nnan nsz i32 %int to float
; CHECK: %h_vec = 有符号转浮点 nnan nsz <3 个 整数32> %ivec 到 <3 个 单精度>
  %h_vec = sitofp nnan nsz <3 x i32> %ivec to <3 x float>
; CHECK:  返回 单精度 %f
  ret float %f
}

; CHECK: @fmf_calls(
define float @fmf_calls(float %x, float %y) {
entry:
; CHECK:  %vec = 加载 <3 个 单精度>, 指针 @vec
  %vec    = load <3 x float>, ptr @vec
; CHECK:  %select = 加载 整数1, 指针 @select
  %select = load i1, ptr @select
; CHECK:  %arr = 加载 [3 个 单精度], 指针 @arr
  %arr    = load [3 x float], ptr @arr

; CHECK:  %a = 调用 nnan ninf afn 单精度 @extfunc(单精度 %x, 单精度 %y)
  %a = call ninf nnan afn float @extfunc(float %x, float %y)
; CHECK:  %a_vec = 调用 reassoc nnan <3 个 单精度> @extfunc_vec(<3 个 单精度> %vec, <3 个 单精度> %vec)
  %a_vec = call reassoc nnan <3 x float> @extfunc_vec(<3 x float> %vec, <3 x float> %vec)
; CHECK:  %b = 调用 nnan ninf afn 单精度 (...) @var_extfunc(单精度 %x, 单精度 %y)
  %b = call ninf nnan afn float (...) @var_extfunc(float %x, float %y)
; CHECK:  %b_vec = 调用 reassoc nnan <3 个 单精度> (...) @var_extfunc_vec(<3 个 单精度> %vec, <3 个 单精度> %vec)
  %b_vec = call reassoc nnan <3 x float> (...) @var_extfunc_vec(<3 x float> %vec, <3 x float> %vec)
; CHECK:  返回 单精度 %a
  ret float %a
}

declare float @extfunc(float, float)
declare <3 x float> @extfunc_vec(<3 x float>, <3 x float>)
declare float @var_extfunc(...)
declare <3 x float> @var_extfunc_vec(...)
