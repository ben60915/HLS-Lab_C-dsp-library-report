#
# Copyright 2021 Xilinx, Inc.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# ----------------
# --- Get Args ---
# ----------------
set dataType            [lindex $argv 0]
set twiddleType         [lindex $argv 1]
set windowSize          [lindex $argv 2]
set pointSize           [lindex $argv 3]
set cascLen             [lindex $argv 4]
set outStatus           [lindex $argv 5]
set uutKernel           [lindex $argv 6]

# ------------------------------------------------
# --- Compute Data Type and Twiddle Type Sizes ---
# ------------------------------------------------
set dataTypeSize 8
if { ($dataType=="cfloat") || ($dataType=="cint32") } {
    set dataTypeSize 4
} 

set twiddleTypeSize 8
if { ($twiddleType=="cfloat") || ($twiddleType=="cint32") } {
    set twiddleTypeSize 4
} 

# ------------------------------
# --- Calculate theoreticals ---
# ------------------------------
# Theoretical Minimum Cycle Count
set minTheoryCycleCount         [expr {$windowSize * int(log($pointSize)/log(2)) / $dataTypeSize / $twiddleTypeSize}]

# Max theoretical throughput in MSa per second
set throughputTheoryMax         [expr {1000 * $windowSize / $minTheoryCycleCount}]

# ----------------------
# --- Display Result ---
# ----------------------
puts "cycleCountTheoryMin:  $minTheoryCycleCount"
puts "throughputTheoryMax:  $throughputTheoryMax MSa/s"

# ----------------------------
# --- Store in status file ---
# ----------------------------
set outFile [open $outStatus a]
puts $outFile "    cycleCountTheoryMin:  $minTheoryCycleCount"
puts $outFile "    throughputTheoryMax:  $throughputTheoryMax MSa/s"
close $outFile


# ------------------------------
# --- Depracated Calculation ---
# ------------------------------
# set firLength [ expr $numBatches * int(log($pointSize/2)/log(2)) / 2 ]
# # set up some constants
# set kAieMacsPerCycle            [expr {128 / $dataTypeSize / $twiddleTypeSize}]
# set effectiveFirLength          [expr {($firLength / $cascLen)}]
# if { $effectiveFirLength == 0 } { 
#     set effectiveFirLength 1
# }
# # Min cycle count (no overhead)
# set minTheoryCycleCount         [expr {($windowSize / $kAieMacsPerCycle) * $effectiveFirLength}]