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

# Warming up --------------------------------------
#                Array    81.000  i/100ms
#          MinimumHeap     1.000  i/100ms
# Calculating -------------------------------------
#                Array    815.959  (± 2.2%) i/s -      4.131k in   5.065284s
#          MinimumHeap      0.965  (± 0.0%) i/s -      5.000  in   5.270911s
#
# Comparison:
#                Array:      816.0 i/s
#          MinimumHeap:        1.0 i/s - 845.29x  slower
#

Benchmark.ips do |x|
  x.config(:suite => suite)

  source_data = []
  1000.times do |inc|
    source_data << ["Title Number #{inc}", 1000 - inc] 
  end
  
  source_nodes = []
  source_data.each do |parms|
    source_nodes << Heaps::Node.new(parms.first, parms.last) 
  end
  a_heap = Heaps::MinimumHeap.new(source_data[0..499])
  b_heap = Heaps::MinimumHeap.new(source_data[500.999])

  x.report('Array') do
    catcher_array = []
    r = Array.new(source_data).sort {|a, b| a.last <=> b.last }
    r.each {|x| catcher_array << x}    
    r.clear
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
