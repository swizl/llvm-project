; RUN: llvm-as < %s | llvm-dis | FileCheck %s
; RUN: verify-uselistorder %s

%struct = type {  }

; CHECK: 声明 空类型 @foo(...)
declare void @foo(...)

; CHECK: 调用 空类型 (...) @foo(指针 byval(%struct) 空指针)
define void @bar() {
	call void (...) @foo(ptr byval(%struct) null )
	ret void
}
