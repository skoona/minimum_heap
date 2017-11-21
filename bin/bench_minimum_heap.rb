#!/usr/bin/env ruby

#
# Ref: https://github.com/evanphx/benchmark-ips
#

require 'bundler/setup'
require 'heaps'
require 'benchmark/ips'

class GCSuite
  def warming(*)
    run_gc
  end

  def running(*)
    run_gc
  end

  def warmup_stats(*)
  end

  def add_report(*)
  end

  private

  def run_gc
    GC.enable
    GC.start
    GC.disable
  end
end

suite = GCSuite.new
##
# Warming up     --------------------------------------
#        Array    56.000  i/100ms
#  MinimumHeap     1.000  i/100ms
#
# Calculating    -------------------------------------
#       Array    551.058  (± 6.9%) i/s -      2.744k in   5.004109s
# MinimumHeap      1.944  (± 0.0%) i/s -     10.000  in   5.273235s
#
# Comparison:
#       Array:      551.1 i/s
# MinimumHeap:        1.9 i/s - 283.50x  slower
##

Benchmark.ips do |x|
  x.config(:suite => suite)

  source_data = []
  1000.times do |inc|
    data = ["Title Number #{inc}", 1000 - inc]
    inc.even? ? source_data.push(data) : source_data.unshift(data)
  end
  
  source_nodes = []
  source_data.each do |parms|
    source_nodes << Heaps::Node.new(parms.first, parms.last) 
  end

  a_heap = Heaps::MinimumHeap.new(source_data[0..499])
  b_heap = Heaps::MinimumHeap.new(source_data[500..999])

  x.report('Array') do
    catcher_array = Array.new
    source_data.each {|y| catcher_array << y} # load each
    catcher_array.sort {|a, b| a.last <=> b.last }
    catcher_array.clear
  end

  x.report('MinimumHeap') do
    nodes_heap = []
    o = b_heap.merge(a_heap)    
    while !o.empty? do
      nodes_heap << o.pop
    end
  end


  x.compare!
end
