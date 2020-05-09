#!/usr/bin/env ruby

require 'io/console'

module AndyDNA
  refine Array do
    def second
      self[1]
    end
  end
end

using AndyDNA

class Tempo
  def self.tap
    puts new.run.report
  end

  def initialize
    @taps = []
  end

  def run
    hello
    loop do
      gotch = STDIN.getch
      break if ["\e", "\r", "\t"].include? gotch
      @taps << Time.now
    end
    self
  end

  def report
    puts "\n#{bpm.round(2)} taps per minute\n\n"
    puts "4/4 downbeats?\t#{bpm.round(2)*4 } bpm"
    puts "3/4 downbeats?\t#{bpm.round(2)*3 } bpm"
    puts "backbeats?\t#{   (bpm*2).round(2)} bpm"
    puts "quarters?\t#{     bpm.round(2)   } bpm"
    puts "eighths?\t#{     (bpm/2).round(2)} bpm"
    puts "triplets?\t#{    (bpm/3).round(2)} bpm"
    puts "sixteenths?\t#{  (bpm/4).round(2)} bpm"
  end

  def hello
    puts "tap almost any key for tempo"
    puts "press return, escape, or tab to finish"
    puts "you may fire when ready"
  end

  def bpm
    begin
    60 / (diffs.sum / diffs.count)
    rescue ZeroDivisionError
      puts "\n\tneed at least two taps\n\n"
      reset
      run
    end
  end

  def diffs
    @diffs ||= @taps.each_cons(2).with_object([]) do |taps, diffs|
      diffs << (taps.second - taps.first)
    end
  end

  def reset
    @taps.clear
    @diffs = nil
  end
end

Tempo.tap
