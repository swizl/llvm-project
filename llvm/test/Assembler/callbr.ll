; RUN: llvm-as < %s | llvm-dis | FileCheck %s

declare void @llvm.amdgcn.kill(i1)

define void @test_kill(i1 %c) {
; CHECK-LABEL: 定义 空类型 @test_kill(
; CHECK-SAME: 整数1 [[C:%.*]]) {
; CHECK-NEXT:    调用分支 空类型 @llvm.amdgcn.kill(整数1 [[C]])
; CHECK-NEXT:            to 标签 %[[CONT:.*]] [标签 %kill]
; CHECK:       [[KILL:.*:]]
; CHECK-NEXT:    不可达
; CHECK:       [[CONT]]:
; CHECK-NEXT:    返回 空类型
;
  callbr void @llvm.amdgcn.kill(i1 %c) to label %cont [label %kill]
kill:
  unreachable
cont:
  ret void
}
