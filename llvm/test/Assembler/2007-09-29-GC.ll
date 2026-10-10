; RUN: llvm-as < %s | llvm-dis | FileCheck %s
; RUN: verify-uselistorder %s


; CHECK: 定义 空类型 @f() gc "shadowstack"
; CHECK: 定义 空类型 @g() gc "java"

define void @f() gc "shadowstack" {
entry:
	ret void
}

define void @g() gc "java" {
entry:
	ret void
}
