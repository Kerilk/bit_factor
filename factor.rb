#!/usr/bin/ruby
require 'prime'

class FactorFound < Exception
  attr_reader :factor1, :factor2
  def initialize(factor1, factor2)
    @factor1 = factor1
    @factor2 = factor2
  end
end

def recursive_bit_shuffle(n, bit_limit, sub1, sub2, partial, rank )
  diff = n - partial
  if diff == 0 then
    return nil if sub1 == 1 or sub2 == 1
    raise FactorFound::new(sub1, sub2)
  end
  return nil if diff < 0
  return nil if sub2.bit_length > bit_limit
  bit = n[rank]
  partial_bit = partial[rank]
  mask = 1 << rank
  if bit ^ partial_bit != 0 then
    bit_shuffle(n, bit_limit, sub1 + mask, sub2, partial + (sub2 << rank), rank+1)
    bit_shuffle(n, bit_limit, sub1, sub2 + mask, partial + (sub1 << rank), rank+1)
  else
    bit_shuffle(n, bit_limit, sub1, sub2, partial, rank+1)
    bit_shuffle(n, bit_limit, sub1 + mask, sub2 + mask, partial + ((sub2 + sub1 + mask) << rank), rank+1)
  end
  return nil
end

def linearized_bit_shuffle(n, sub1, sub2, partial, rank )
    
end

alias bit_shuffle recursive_bit_shuffle

def split(n)

  begin
    bit_shuffle(n, n.bit_length/2, 1, 1, 1, 1 )
    return [n]
  rescue FactorFound => e
    return split( e.factor1 ) + split( e.factor2 )
  end
end

def factor(num)

  factors = []

  if num < 0 then
    factors.push -1
    num = num.abs
  end

  while num.even? do
    num >>= 1
    factors.push 2
  end

  if num > 1 then
    factors += split(num)
  end
  return factors
end

llimit = 0
llimit = ARGV[0].to_i if ARGV[0] and ARGV[0] != ""
llimit = 2 unless llimit > 2

ulimit = 0
ulimit = ARGV[1].to_i if ARGV[1] and ARGV[1] != ""
ulimit = llimit unless ulimit > llimit

(llimit..ulimit).each { |num_orig|
  factors = factor(num_orig)
  puts "#{num_orig} = #{factors.sort.inspect}"
}

#  puts num_orig
#  pf = Prime.prime_division(num_orig)
#  prime_factors = []
#  pf.each { |e, times|
#    prime_factors += [e]*times
#  }
##  puts "#{num_orig} is pimes? #{prime}"
#  factors = factor(num_orig)
##  puts "#{num_orig} = #{factors.sort.join("*")}"
#  raise "Wrong decomposition! (#{prime_factors.sort.inspect} != #{factors.sort.inspect}" unless prime_factors.sort == factors.sort
#}
