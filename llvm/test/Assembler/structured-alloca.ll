; RUN: llvm-as < %s | llvm-dis

%S = type { i32, i32 }

define void @simple_scalar_allocation() {
entry:
; CHECK: %ptr = 调用 elementtype(整数32) 指针 @llvm.structured.alloca.p0()
  %ptr = call elementtype(i32) ptr @llvm.structured.alloca()
  ret void
}

define void @struct_allocation() {
entry:
; CHECK: %ptr = 调用 elementtype(%S) 指针 @llvm.structured.alloca.p0()
  %ptr = call elementtype(%S) ptr @llvm.structured.alloca()
  ret void
}
