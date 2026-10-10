; RUN: not llvm-as < %s 2>&1 | FileCheck %s

; CHECK: invalid cast opcode for cast from '<4 个 整数64>' to '<3 个 整数8>'

define <3 x i8> @foo(<4 x i64> %x) {
  %y = trunc <4 x i64> %x to <3 x i8>
  ret <3 x i8> %y
}
