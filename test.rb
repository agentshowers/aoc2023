#!/usr/bin/env ruby


def find_candidate(ns)
  sum = []
  acc = 0
  ns.each do |n|
    acc += n
    sum << acc
  end
  
  i = 0
  res = []
  while i <= ns.length - 2
    if i >= (ns.length / 2.0).floor
      l = (i+1) * 2 - ns.length
      r = ns.length - 1
    else
      l = 0
      r = (i * 2) + 1
    end

    l_sum = sum[i] - (l == 0 ? 0 : sum[l-1])
    r_sum = sum[r] - sum[i]

    diff = (l_sum - r_sum).abs
    res << diff
    i += 1
  end
  res
end

cands = find_candidate([358, 90, 385, 385, 90, 102, 346])
cands.each do |c|
  puts c.to_s(2)
end