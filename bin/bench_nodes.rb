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
#             BaseNode    84.000  i/100ms
#                 Node    87.000  i/100ms
# Calculating -------------------------------------
#             BaseNode    713.986  (±22.1%) i/s -      3.444k in   5.088723s
#                 Node    868.557  (±21.3%) i/s -      4.176k in   5.054092s
#
# Comparison:
#                Node:      868.6 i/s
#            BaseNode:      714.0 i/s - same-ish: difference falls within error
##

Benchmark.ips do |x|
  x.config(:suite => suite)

  source_data = []
  1000.times do |inc|
    source_data << ["Title Number #{inc}", 1000 - inc]
  end

  x.report('BaseNode') do
    r = source_data.map {|v| Heaps::BaseNode.new(v.first, v.last) }
    r.clear
  end

  x.report('Node') do
    r = source_data.map {|v| Heaps::Node.new(v.first, v.last) }
    r.clear
  end

  x.compare!
end
