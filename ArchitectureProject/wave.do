onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /sisc_tb/uut/i9/instr
add wave -noupdate -radix hexadecimal {/sisc_tb/uut/i12/ram_array[3]}
add wave -noupdate -radix hexadecimal {/sisc_tb/uut/i12/ram_array[2]}
add wave -noupdate -radix hexadecimal {/sisc_tb/uut/i12/ram_array[1]}
add wave -noupdate -radix hexadecimal {/sisc_tb/uut/i12/ram_array[0]}
add wave -noupdate -radix hexadecimal {/sisc_tb/uut/i4/ram_array[3]}
add wave -noupdate -radix hexadecimal {/sisc_tb/uut/i4/ram_array[2]}
add wave -noupdate -radix hexadecimal {/sisc_tb/uut/i4/ram_array[1]}
add wave -noupdate -radix hexadecimal {/sisc_tb/uut/i4/ram_array[0]}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {214900 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 208
configure wave -valuecolwidth 40
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
WaveRestoreZoom {181300 ps} {238900 ps}
