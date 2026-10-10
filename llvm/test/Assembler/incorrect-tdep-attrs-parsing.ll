; RUN: llvm-as < %s | llvm-dis | FileCheck %s

; CHECK: 定义 整数32 @f(整数64 "foo bar" %0, 整数64 %1, 整数64 %2, 整数64 "xyz" %3) {
define i32 @f(i64 "foo bar", i64, i64, i64 "xyz") {
  ret i32 41
}
