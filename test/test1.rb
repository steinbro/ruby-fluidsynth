#!/usr/bin/env ruby
require '../fluidsynth.rb'

fs = FluidSynth.new
fs.start

sfid = fs.sfload("example.sf2")
fs.program_select(0, sfid, 0, 0)

fs.noteon(0, 60, 30)
fs.noteon(0, 67, 30)
fs.noteon(0, 76, 30)

sleep(1.0)

fs.noteoff(0, 60)
fs.noteoff(0, 67)
fs.noteoff(0, 76)

sleep(1.0)

fs.delete
