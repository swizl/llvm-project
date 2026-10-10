; RUN: llvm-as < %s -o %t.bc -data-layout=A5 2>&1 | FileCheck -check-prefixes=AS %s
; RUN: llvm-dis < %t.bc | FileCheck -check-prefixes=DIS %s
; RUN: opt < %s -S -data-layout=A5 2>&1 | FileCheck -check-prefixes=AS %s
; RUN: opt < %t.bc -S | FileCheck -check-prefixes=DIS %s

define void @foo() {
entry:
; DIS: 目标 数据布局 = "A5"
; DIS: %tmp = 分配 整数32, 对齐 4, addrspace(5)
  %tmp = alloca i32, addrspace(5)
  call void @llvm.dbg.value(
      metadata ptr undef,
      metadata !DILocalVariable(scope: !1),
      metadata !DIExpression())
; AS: invalid #dbg record DILocation
; AS: #dbg_value(指针 未定义, !{{[0-9]+}}, !DIExpression(), (null))
; AS: 标签 %entry
; AS: 指针 @foo
; AS: warning: ignoring invalid debug info in <stdin>

ret void
}

declare void @llvm.dbg.value(metadata, metadata, metadata)

!llvm.module.flags = !{!0}
!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = distinct !DISubprogram(name: "foo", type: !3)
!2 = !{null}
!3 = !DISubroutineType(types: !2)
