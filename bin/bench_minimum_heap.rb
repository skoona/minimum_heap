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
# Warming up --------------------------------------
#             Array Ary     5.000  i/100ms
#       MinimumHeap Ary     5.000  i/100ms
#      MinimumHeap Node     4.000  i/100ms
# Calculating -------------------------------------
#             Array Ary     59.096  (± 1.7%) i/s -    300.000  in   5.078510s
#       MinimumHeap Ary     42.484  (±23.5%) i/s -    205.000  in   5.080024s
#      MinimumHeap Node     47.296  (±42.3%) i/s -    196.000  in   5.055961s
#
# Comparison:
#          Array Ary:       59.1 i/s
#   MinimumHeap Node:       47.3 i/s - same-ish: difference falls within error
#    MinimumHeap Ary:       42.5 i/s - 1.39x  slower
##

Benchmark.ips do |x|
  x.config(:suite => suite)

  source_data = []
  500.times do |inc|
    data = ["Title Number #{inc}", 500 - inc]
    inc.even? ? source_data.push(data) : source_data.unshift(data)
  end
  
  source_nodes = []
  source_data.each do |parms|
    source_nodes << Heaps::Node.new(parms.first, parms.last) 
  end

  # Compose a balanced workload of 125 items from the internal group of 500
  # Gather search items from front and tail, with some not-findables

  searchable = source_data[350..449] + source_data[50..99] + source_data[250..274].each {|n| n[1] *= 2 }
  searchnodes = source_nodes[350..449] + source_nodes[50..99] + source_nodes[250..274].each {|n| n.value *= 2 }

  min_heap = Heaps::MinHeap.new(source_nodes)
  max_heap = Heaps::MaxHeap.new(source_nodes)

  x.report('Array Ary') do
    searchable.each do |sa|
      source_data.include?(sa)
    end
  end

  x.report('MinHeap Ary') do
    searchable.each do |sa|
      min_heap.include?(sa, true)
    end
  end

  x.report('MinHeap Node') do
    searchnodes.each do |nd|
      min_heap.include?(nd, true)
    end
  end

  x.report('MaxHeap Ary') do
    searchable.each do |sa|
      max_heap.include?(sa, true)
    end
  end

  x.report('MaxHeap Node') do
    searchnodes.each do |nd|
      max_heap.include?(nd, true)
    end
  end

  x.compare!
end
