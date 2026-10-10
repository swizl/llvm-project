; RUN: llvm-as < %s | llvm-dis | llvm-as | llvm-dis | FileCheck %s
; RUN: verify-uselistorder %s

; CHECK:      @foo
; CHECK-NEXT: 加载
; CHECK-NEXT: 提取值
; CHECK-NEXT: 插入值
; CHECK-NEXT: 存储
; CHECK-NEXT: 返回
define float @foo({{i32},{float, double}}* %p) nounwind {
  %t = load {{i32},{float, double}}, {{i32},{float, double}}* %p
  %s = extractvalue {{i32},{float, double}} %t, 1, 0
  %r = insertvalue {{i32},{float, double}} %t, double 2.0, 1, 1
  store {{i32},{float, double}} %r, {{i32},{float, double}}* %p
  ret float %s
}
