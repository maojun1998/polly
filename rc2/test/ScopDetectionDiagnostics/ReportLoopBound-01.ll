; RUN: opt %loadPolly -pass-remarks-missed="polly-detect" -polly-detect-track-failures -polly-detect -analyze < %s 2>&1| FileCheck %s

; void f(int A[], int n) {
;   for (int i = 0; i < A[n]; i++)
;     A[i] = 0;
; }

; CHECK: remark: ReportLoopBound-01.c:2:8: The following errors keep this region from being a Scop.
; CHECK: remark: ReportLoopBound-01.c:2:8: Failed to derive an affine function from the loop bounds.
; CHECK: remark: ReportLoopBound-01.c:3:5: Invalid Scop candidate ends here.

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

define void @f(i32* %A, i32 %n) {
entry:
  br label %entry.split

entry.split:                                      ; preds = %entry
  tail call void @llvm.dbg.value(metadata i32* %A, i64 0, metadata !13), !dbg !14
  tail call void @llvm.dbg.value(metadata i32 %n, i64 0, metadata !15), !dbg !16
  tail call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !18), !dbg !20
  %idxprom = sext i32 %n to i64, !dbg !21
  %arrayidx = getelementptr inbounds i32* %A, i64 %idxprom, !dbg !21
  %0 = load i32* %arrayidx, align 4, !dbg !21
  %cmp3 = icmp sgt i32 %0, 0, !dbg !21
  br i1 %cmp3, label %for.body.lr.ph, label %for.end, !dbg !21

for.body.lr.ph:                                   ; preds = %entry.split
  br label %for.body, !dbg !22

for.body:                                         ; preds = %for.body.lr.ph, %for.body
  %indvar = phi i64 [ 0, %for.body.lr.ph ], [ %indvar.next, %for.body ]
  %arrayidx2 = getelementptr i32* %A, i64 %indvar, !dbg !24
  %1 = add i64 %indvar, 1, !dbg !24
  %inc = trunc i64 %1 to i32, !dbg !21
  store i32 0, i32* %arrayidx2, align 4, !dbg !24
  tail call void @llvm.dbg.value(metadata !{null}, i64 0, metadata !18), !dbg !20
  %2 = load i32* %arrayidx, align 4, !dbg !21
  %cmp = icmp slt i32 %inc, %2, !dbg !21
  %indvar.next = add i64 %indvar, 1, !dbg !21
  br i1 %cmp, label %for.body, label %for.cond.for.end_crit_edge, !dbg !21

for.cond.for.end_crit_edge:                       ; preds = %for.body
  br label %for.end, !dbg !25

for.end:                                          ; preds = %for.cond.for.end_crit_edge, %entry.split
  ret void, !dbg !27
}

declare void @llvm.dbg.declare(metadata, metadata)

declare void @llvm.dbg.value(metadata, i64, metadata)

attributes #0 = { nounwind uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!10, !11}
!llvm.ident = !{!12}

!0 = !{!"0x11\0012\00clang version 3.6.0 \000\00\000\00\001", !1, !2, !2, !3, !2, !2} ; [ DW_TAG_compile_unit ] [test/ScopDetectionDiagnostic/ReportLoopBound-01.c] [DW_LANG_C99]
!1 = !{!"ReportLoopBound-01.c", !"test/ScopDetectionDiagnostic/"}
!2 = !{}
!3 = !{!4}
!4 = !{!"0x2e\00f\00f\00\001\000\001\000\006\00256\000\001", !1, !5, !6, null, void (i32*, i32)* @f, null, null, !2} ; [ DW_TAG_subprogram ] [line 1] [def] [f]
!5 = !{!"0x29", !1}          ; [ DW_TAG_file_type ] [test/ScopDetectionDiagnostic/ReportLoopBound-01.c]
!6 = !{!"0x15\00\000\000\000\000\000\000", i32 0, null, null, !7, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!7 = !{null, !8, !9}
!8 = !{!"0xf\00\000\0064\0064\000\000", null, null, !9} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from int]
!9 = !{!"0x24\00int\000\0032\0032\000\000\005", null, null} ; [ DW_TAG_base_type ] [int] [line 0, size 32, align 32, offset 0, enc DW_ATE_signed]
!10 = !{i32 2, !"Dwarf Version", i32 4}
!11 = !{i32 2, !"Debug Info Version", i32 2}
!12 = !{!"clang version 3.6.0 "}
!13 = !{!"0x101\00A\0016777217\000", !4, !5, !8} ; [ DW_TAG_arg_variable ] [A] [line 1]
!14 = !{i32 1, i32 12, !4, null}
!15 = !{!"0x101\00n\0033554433\000", !4, !5, !9} ; [ DW_TAG_arg_variable ] [n] [line 1]
!16 = !{i32 1, i32 21, !4, null}
!17 = !{i32 0}
!18 = !{!"0x100\00i\002\000", !19, !5, !9} ; [ DW_TAG_auto_variable ] [i] [line 2]
!19 = !{!"0xb\002\003\000", !1, !4} ; [ DW_TAG_lexical_block ] [test/ScopDetectionDiagnostic/ReportLoopBound-01.c]
!20 = !{i32 2, i32 12, !19, null}
!21 = !{i32 2, i32 8, !19, null}
!22 = !{i32 2, i32 8, !23, null}
!23 = !{!"0xb\002\008\001", !1, !19} ; [ DW_TAG_lexical_block ] [test/ScopDetectionDiagnostic/ReportLoopBound-01.c]
!24 = !{i32 3, i32 5, !19, null}
!25 = !{i32 2, i32 8, !26, null}
!26 = !{!"0xb\002\008\002", !1, !19} ; [ DW_TAG_lexical_block ] [test/ScopDetectionDiagnostic/ReportLoopBound-01.c]
!27 = !{i32 4, i32 1, !4, null}
