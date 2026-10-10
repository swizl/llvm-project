; RUN: llvm-as < %s | llvm-dis | llvm-as | llvm-dis | FileCheck %s
; RUN: verify-uselistorder %s

; CHECK: @foo
; CHECK: 存储 { 整数32, 整数32 } { 整数32 7, 整数32 9 }, 指针 %x
; CHECK: 返回
define void @foo(ptr %x) nounwind {
  store {i32, i32}{i32 7, i32 9}, ptr %x
  ret void
}

; CHECK: @foo_empty
; CHECK: 存储 {} 零初始化, 指针 %x
; CHECK: 返回
define void @foo_empty(ptr %x) nounwind {
  store {}{}, ptr %x
  ret void
}

; CHECK: @bar
; CHECK: 存储 [2 个 整数32] [整数32 7, 整数32 9], 指针 %x
; CHECK: 返回
define void @bar(ptr %x) nounwind {
  store [2 x i32][i32 7, i32 9], ptr %x
  ret void
}

; CHECK: @bar_empty
; CHECK: 存储 [0 个 整数32] 毒药值, 指针 %x
; CHECK: 返回
define void @bar_empty(ptr %x) nounwind {
  store [0 x i32][], ptr %x
  ret void
}

; CHECK: @qux
; CHECK: 存储 <{ 整数32, 整数32 }> <{ 整数32 7, 整数32 9 }>, 指针 %x
; CHECK: 返回
define void @qux(ptr %x) nounwind {
  store <{i32, i32}><{i32 7, i32 9}>, ptr %x
  ret void
}

; CHECK: @qux_empty
; CHECK: 存储 <{}> 零初始化, 指针 %x
; CHECK: 返回
define void @qux_empty(ptr %x) nounwind {
  store <{}><{}>, ptr %x
  ret void
}

; CHECK: @fixed_ptr_null_splat
; CHECK: 返回 <2 个 指针> splat (指针 空指针)
; DISABLED: @fixed_ptr_null_splat
; DISABLED: ret <2 个 ptr> zeroinitializer
define <2 x ptr> @fixed_ptr_null_splat() {
  ret <2 x ptr> zeroinitializer
}

; CHECK: @scalable_ptr_null_splat
; CHECK: 返回 <vscale x 2 个 指针> splat (指针 空指针)
; DISABLED: @scalable_ptr_null_splat
; DISABLED: ret <vscale x 2 个 ptr> zeroinitializer
define <vscale x 2 x ptr> @scalable_ptr_null_splat() {
  ret <vscale x 2 x ptr> zeroinitializer
}

; CHECK: @explicit_fixed_ptr_null_splat
; CHECK: 返回 <2 个 指针> splat (指针 空指针)
; DISABLED: @explicit_fixed_ptr_null_splat
; DISABLED: ret <2 个 ptr> zeroinitializer
define <2 x ptr> @explicit_fixed_ptr_null_splat() {
  ret <2 x ptr> splat (ptr null)
}
