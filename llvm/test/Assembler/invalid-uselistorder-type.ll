; RUN: not llvm-as < %s -disable-output 2>&1 | FileCheck %s
; CHECK: error: '%x' defined with type '整数32' but expected '单精度'
define void @test(i32 %x) {
  ret void

  uselistorder float %x, { 1, 0 }
}
