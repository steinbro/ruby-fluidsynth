#!/usr/bin/env ruby
require '../fluidsynth.rb'

fs = FluidSynth.new
fs.start

sfid = fs.sfload("/Users/jj/Downloads/FluidR3_GM.sf2",1)
#fs.program_select(0, sfid, 0, 0)

fs.play_file("/Users/jj/Desktop/badboys_xg.mid")

sleep 30

fs.delete
