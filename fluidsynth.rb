#!/usr/bin/env ruby
#
# Ruby bindings for FluidSynth
#
# Daniel W. Steinbrook <dsteinbrook@gmail.com>
# Based on pyFluidSynth, released under the LGPL.
# 
# For documentation, see pyFluidSynth:
#   http://pypi.python.org/pypi/pyFluidSynth
#

require 'dl/import'
require 'test/unit/assertions'

class FluidSynth
  module C
    extend DL::Importer
    begin
      dlload 'libfluidsynth.dylib'
    rescue
      raise LoadError, "Couldn't find the FluidSynth library."
    end

    extern 'void* new_fluid_settings()'
    extern 'void* new_fluid_synth(void*)'
    extern 'void* new_fluid_audio_driver(void*, void*)'

    extern 'int fluid_settings_setstr(void*, char*, char*)'
    extern 'int fluid_settings_setnum(void*, char*, double)'
    extern 'int fluid_settings_setint(void*, char*, int)'

    extern 'void delete_fluid_audio_driver(void*)'
    extern 'void delete_fluid_synth(void*)'
    extern 'void delete_fluid_settings(void*)'

    extern 'int fluid_synth_sfload(void*, char*, int)'
    extern 'int fluid_synth_sfunload(void*, int, int)'
    extern 'int fluid_synth_program_select(void*, int, int, int, int)'
    extern 'int fluid_synth_noteon(void*, int, int, int)'
    extern 'int fluid_synth_noteoff(void*, int, int)'
    extern 'int fluid_synth_pitch_bend(void*, int, int)'
    extern 'int fluid_synth_cc(void*, int, int, int)'
    extern 'int fluid_synth_program_change(void*, int, int)'
    extern 'int fluid_synth_bank_select(void*, int, int)'
    extern 'int fluid_synth_sfont_select(void*, int, int)'

    extern 'int fluid_synth_program_reset(void*)'
    extern 'int fluid_synth_system_reset(void*)'

    extern 'void* fluid_synth_write_s16(void*, int, void*, int, int, void*, int, int)'
  end

  def initialize(gain=0.2, samplerate=44100.0)
    @settings = C.new_fluid_settings
    C.fluid_settings_setnum(@settings, 'synth.gain', gain)
    C.fluid_settings_setnum(@settings, 'synth.sample-rate', samplerate)

    C.fluid_settings_setint(@settings, 'synth.midi-channels', 256)
    @synth = C.new_fluid_synth(@settings)
    @audio_driver = nil
  end

  def start(driver=nil)
    if not driver.nil?
      Test::Unit::Assertions.assert(['alsa', 'oss', 'jack', 'portaudio', 'sndmgr', 'coreaudio', 'Direct Sound'].include?(driver))
      C.fluid_settings_setstr(@settings, 'audio.driver', driver)
    end
    @audio_driver = C.new_fluid_audio_driver(@settings, @synth)
  end

  def delete
    if not @audio_driver.nil?
      C.delete_fluid_audio_driver(@audio_driver)
    end
    C.delete_fluid_synth(@synth)
    C.delete_fluid_settings(@settings)
  end

  def sfload(filename, update_midi_preset=0)
    C.fluid_synth_sfload(@synth, filename, update_midi_preset)
  end

  def sfunload(sfid, update_midi_preset=0)
    C.fluid_synth_sfunload(@synth, sfid, update_midi_preset)
  end

  def program_select(chan, sfid, bank, preset)
    C.fluid_synth_program_select(@synth, chan, sfid, bank, preset)
  end

  def noteon(chan, key, vel)
    if key < 0 or key > 128 or chan < 0 or vel < 0 or vel > 128
      return false
    else
      return C.fluid_synth_noteon(@synth, chan, key, vel)
    end
  end

  def noteoff(chan, key)
    if key < 0 or key > 128 or chan < 0
      return false
    else
      return C.fluid_synth_noteoff(@synth, chan, key)
    end
  end

  def pitch_bend(chan, val)
    C.fluid_synth_pitch_bend(@synth, chan, val + 8192)
  end

  def cc(chan, ctrl, val)
    C.fluid_synth_cc(@synth, chan, ctrl, val)
  end

  def program_change(chan, prg)
    C.fluid_synth_program_change(@synth, chan, prg)
  end

  def bank_select(chan, bank)
    C.fluid_synth_bank_select(@synth, chan, bank)
  end

  def sfont_select(chan, sfid)
    C.fluid_synth_sfont_select(@synth, chan, sfid)
  end

  def program_reset
    C.fluid_synth_program_reset(@synth)
  end

  def system_reset
    C.fluid_synth_system_reset(@synth)
  end
end
