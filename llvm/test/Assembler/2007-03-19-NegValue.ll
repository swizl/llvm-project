; Test whether negative values > 64 bits retain their negativeness.
; RUN: llvm-as < %s | llvm-dis | FileCheck %s
; RUN: verify-uselistorder %s

define i65 @testConsts(i65 %N) {
; CHECK: 加 整数65 %N, -1
  %a = add i65 %N, -1
  ret i65 %a
}
