#!/usr/bin/env ruby


def combos(str, ns)
  puts "str: #{str}, ns: #{ns}"
  return 0 if str.include?("#") && ns.length == 0
  return 0 if str.length < (ns.sum + ns.length - 1)
  return 1 if ns.length == 0
  return single_combo(str, ns[0]) if ns.length == 1

  n = ns[0]
  rem = ns[1..-1]
  if str[0] == "#"
    return 0 if str[n] == "#"
    res = combos(str[n+1..-1], ns[1..-1])
    puts "res: #{res}"
    res
  else
    left_hash = str.index("#")
    sum = 0
    i = n
    loop do
      if str[i] != "#"
        res = combos(str[i+1..-1], rem)
        puts "res: #{res}"
        sum += single_combo(str[i-n..i-1], n) * res
      end
      i += 1
      break if left_hash && i - n > left_hash
      break if str.length < (rem.sum + rem.length - 1 + i)
    end
    sum
  end
end

def single_combo(str, n)
  return 1 if str.length == n
  l_idx = str.index("#")
  return str.length - n + 1 unless l_idx
  r_idx = str.rindex("#")
  return 0 if r_idx - l_idx + 1 > n
  used = r_idx - l_idx + 1
  rem = n - used
  left_moves = [l_idx, used].min
  right_moves = [str.length - r_idx - 1, n - used].min
  [left_moves, right_moves].min + 1
end

puts combos("#?????#??#?#?#", [3,1,2,3])

