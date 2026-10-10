; RUN: not llvm-as < %s 2>&1 | FileCheck %s

; CHECK: invalid forward reference to function 'f' with wrong type: expected '指针' but was '指针 addrspace(1)'

@a = alias void (), ptr addrspace(1) @f

define void @f() {
  ret void
}
