onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /hisBuilderTB/hisBuilderrFSMU0/clk
add wave -noupdate /hisBuilderTB/hisBuilderrFSMU0/res
add wave -noupdate /hisBuilderTB/hisBuilderrFSMU0/wrEn
add wave -noupdate /hisBuilderTB/hisBuilderrFSMU0/data
add wave -noupdate /hisBuilderTB/hisBuilderrFSMU0/result
add wave -noupdate /hisBuilderTB/hisBuilderrFSMU0/stateRAM
add wave -noupdate /hisBuilderTB/hisBuilderrFSMU0/addr
add wave -noupdate /hisBuilderTB/hisBuilderrFSMU0/input_count
add wave -noupdate /hisBuilderTB/hisBuilderrFSMU0/pixel_count
add wave -noupdate /hisBuilderTB/hisBuilderrFSMU0/pixel_countt
add wave -noupdate /hisBuilderTB/hisBuilderrFSMU0/pixel_counttt
add wave -noupdate /hisBuilderTB/hisBuilderrFSMU0/acq_count
add wave -noupdate /hisBuilderTB/hisBuilderrFSMU0/inside_ress
add wave -noupdate /hisBuilderTB/hisBuilderrFSMU0/inside_resss
add wave -noupdate /hisBuilderTB/hisBuilderrFSMU0/inside_res
add wave -noupdate /hisBuilderTB/hisBuilderrFSMU0/inside_res1
add wave -noupdate /hisBuilderTB/hisBuilderrFSMU0/iinside_res
add wave -noupdate /hisBuilderTB/hisBuilderrFSMU0/peakDonee
add wave -noupdate /hisBuilderTB/hisBuilderrFSMU0/binCounts
add wave -noupdate /hisBuilderTB/hisBuilderrFSMU0/hisNumm
add wave -noupdate /hisBuilderTB/hisBuilderrFSMU0/addrr
add wave -noupdate -expand /hisBuilderTB/hisBuilderrFSMU0/BRAM
add wave -noupdate /hisBuilderTB/hisBuilderrFSMU0/hisNum
add wave -noupdate /hisBuilderTB/hisBuilderrFSMU0/combin_res
add wave -noupdate /hisBuilderTB/hisBuilderrFSMU0/acq_count_finish
add wave -noupdate /hisBuilderTB/hisBuilderrFSMU0/peakDone
add wave -noupdate /hisBuilderTB/hisBuilderrFSMU0/SB
add wave -noupdate /hisBuilderTB/hisBuilderrFSMU0/upperBound
add wave -noupdate /hisBuilderTB/hisBuilderrFSMU0/upperBoundCH
add wave -noupdate /hisBuilderTB/hisBuilderrFSMU0/y
add wave -noupdate /hisBuilderTB/hisBuilderrFSMU0/interData
add wave -noupdate /hisBuilderTB/hisBuilderrFSMU0/x
add wave -noupdate /hisBuilderTB/hisBuilderrFSMU0/i
add wave -noupdate /hisBuilderTB/hisBuilderrFSMU0/THminus
add wave -noupdate /hisBuilderTB/hisBuilderrFSMU0/THpositive
add wave -noupdate /hisBuilderTB/hisBuilderrFSMU0/delta
add wave -noupdate /hisBuilderTB/hisBuilderrFSMU0/SB
add wave -noupdate /hisBuilderTB/hisBuilderrFSMU0/CH
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {30000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 308
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {268400 ps}
