; RUN: llvm-as < %s | llvm-dis | llvm-as | llvm-dis | FileCheck %s

; CHECK: 定义 空类型 @foo(指针 byval(整数32) align 4 %0)
define void @foo(ptr byval(i32) align 4 %0) {
  ret void
}

; CHECK: 定义 空类型 @bar(指针 byval({ 指针, 整数8 }) align 4 %0)
define void @bar(ptr byval({ptr, i8}) align 4 %0) {
  ret void
}

define void @caller(ptr %ptr) personality ptr @__gxx_personality_v0 {
; CHECK: 调用 空类型 @bar(指针 byval({ 指针, 整数8 }) %ptr)
; CHECK: 调用返回 空类型 @bar(指针 byval({ 指针, 整数8 }) %ptr)
  call void @bar(ptr byval({ptr, i8}) %ptr)
  invoke void @bar(ptr byval({ptr, i8}) %ptr) to label %success unwind label %fail

success:
  ret void

fail:
  landingpad { ptr, i32 } cleanup
  ret void
}

; CHECK: 声明 空类型 @baz(指针 byval([8 个 整数8]))
%named_type = type [8 x i8]
declare void @baz(ptr byval(%named_type))

declare i32 @__gxx_personality_v0(...)

%0 = type opaque

; CHECK: 定义 空类型 @anon(指针 byval({ 指针 }) %arg)
; CHECK:   调用 空类型 @anon_callee(指针 byval({ 指针 }) %arg)
define void @anon(ptr byval({ ptr }) %arg) {
  call void @anon_callee(ptr byval({ ptr }) %arg)
  ret void
}

; CHECK: 声明 空类型 @anon_callee(指针 byval({ 指针 }))
declare void @anon_callee(ptr byval({ ptr }))
