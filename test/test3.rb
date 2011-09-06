#!/usr/bin/env ruby
require '../fluidsynth.rb'

fs = FluidSynth.new
fs.start

sfid = fs.sfload("example.sf2")
fs.program_select(0, sfid, 0, 0)

fs.noteon(0, 60, 30)
sleep(0.3)

10.times do |i|
  fs.cc(0, 93, 127)
  fs.pitch_bend(0, i * 512)
  sleep(0.1)
end

fs.noteoff(0, 60)

sleep(1.0)

fs.delete
