import random
import sys
import array

perms = 0
use_memo = False
memo = {}

def rounds(orig_d1, orig_d2, debug = False):
  
  if (use_memo and (str(orig_d1) + str(orig_d2)) in memo):
    print("found memo!{}\n{}\n{}".format(orig_d1, orig_d2,memo[str(orig_d1) + str(orig_d2)]))
    sys.exit(0)
    return memo[str(orig_d1) + str(orig_d2)]

  d1 = orig_d1.copy()
  d2 = orig_d2.copy()

  #print("d1: {}".format(d1))
  #print("d2: {}".format(d2))
  rv = 0
  
  while (len(d1) > 0 and len(d2) > 0):

    finished = False

    d1_stack = []
    d2_stack = []

    if (rv > 6000 and rv % 10 == 0):
      print("{} rounds:{}".format(perms, rv), end="\r")

    if (debug or rv == 6000):
      print("  {} d1: {}".format(rv, d1))    
      print("  {} d2: {}".format(rv, d2))

    while (d1[0] == d2[0]):

      if (debug):
        print("    -> {} d1: {}".format(rv, d1))    
        print("    -> {} d2: {}".format(rv, d2))

      d1_stack += d1[:2]
      d2_stack += d2[:2]

      d1 = d1[2:]
      d2 = d2[2:]

      if (len(d1) == 0 or len(d2) == 0):
        finished = True
        rv += 1
        break

    if (finished):
      break

    d1top = d1.pop(0)
    d2top = d2.pop(0)
   
    if (d1top > d2top):
      d1 = d1 + d1_stack + [d1top] + d2_stack + [d2top]
    elif (d2top > d1top): # really is else since == is covered above
      d2 = d2 + d2_stack + [d2top] + d1_stack + [d1top]

    rv += 1

    if (rv > 1 and len(d1) == len(orig_d1) and len(orig_d2)):
      if (debug):
          print("Base deck found!\n  d1: {}\n  d2: {}\n   Found after: {} rounds".format(d1, d2, rv))
      rv += rounds(d1, d2)
      break

    if ((d1 == orig_d1 and d2 == orig_d2) or (d1 == orig_d2 and d2 == orig_d1)):
      print("recursive deck found!\n  d1: {}\n  d2: {}\n   Recursed after: {} rounds".format(d1, d2, rv))
      sys.exit(0)

  if (use_memo):
    memo[str(orig_d1) + str(orig_d2)] = rv

  return rv

d1 = [1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12,13,13]
d2 = [1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12,13,13]

print("1: rounds: {}".format(rounds(d1, d2)))

d1 = [10,4,4,4,13,10,13,12,8,9,2,8,2,7,11,11,1,3,2,9,12,7,11,12,6,6]
d2 = [5,10,9,3,2,5,11,10,3,5,13,4,1,8,1,5,7,13,9,8,3,1,6,7,12,6]

print("2: rounds: {}".format(rounds(d1, d2)))

d1 = [3, 11, 8, 11, 9, 6, 4, 13, 2, 10, 8, 11, 4, 8, 7, 12, 9, 13, 3, 10, 6, 7, 2, 3, 7, 6]
d2 = [7, 8, 4, 5, 11, 6, 10, 10, 12, 3, 12, 12, 1, 9, 2, 9, 5, 5, 1, 13, 13, 1, 5, 1, 2, 4]

print("3: rounds: {}".format(rounds(d1, d2)))

d1 = [7, 8, 1, 6, 3, 5, 7, 10, 8, 2, 9, 1, 8, 13, 9, 5, 11, 11, 7, 10, 3, 5, 12, 13, 4, 1]
d2 = [11, 11, 9, 12, 12, 12, 4, 4, 10, 2, 6, 3, 3, 13, 9, 13, 5, 2, 1, 6, 8, 6, 7, 2, 10, 4]

print("4: rounds: {}".format(rounds(d1, d2)))

d1 = [4, 12, 7, 2, 3, 9, 9, 1, 11, 6, 11, 1, 5, 7, 4, 2, 4, 3, 8, 13, 5, 1, 5, 7, 5, 12]
d2 = [7, 2, 10, 11, 13, 1, 8, 6, 10, 3, 12, 12, 13, 8, 3, 10, 9, 10, 11, 2, 9, 13, 6, 6, 4, 8]

print("5: rounds: {}".format(rounds(d1, d2)))

d1 =  [10, 8, 12, 5, 7, 8, 2, 10, 4, 11, 3, 13, 6, 3, 6, 5, 12, 3, 11, 12, 9, 1, 2, 9, 4, 2]
d2 = [7, 11, 13, 3, 7, 6, 8, 10, 5, 1, 10, 7, 8, 13, 11, 2, 9, 5, 9, 6, 4, 12, 1, 1, 4, 13]

print("6: rounds: {}".format(rounds(d1, d2)))

d1 = [13, 12, 13, 12, 11, 10, 11, 10, 9, 8, 9, 8, 7, 6, 7, 6, 5, 4, 5, 4, 3, 2, 3, 1, 2, 1]
d2 = [12, 13, 12, 13, 10, 11, 10, 11, 8, 9, 8, 9, 6, 7, 6, 7, 4, 5, 4, 5, 2, 3, 1, 3, 1, 2]

print("7: rounds: {}".format(rounds(d1, d2)))

d1 = [2, 2, 1, 2, 3, 4, 1, 4]
d2 = [3, 3, 4, 2, 3, 4, 1, 1]

d1 = [2, 2, 1, 2, 3, 4, 1, 4, 6, 6, 5, 6, 7, 8, 5, 8]
d2 = [3, 3, 4, 2, 3, 4, 1, 1, 7, 7, 8, 6, 7, 8, 5, 5]   

#1300
d1 = [3, 4, 2, 9, 8, 4, 4, 3, 3, 6, 8, 6, 9, 8, 9, 5, 7, 1]
d2 = [8, 7, 3, 5, 2, 7, 6, 1, 5, 2, 4, 9, 1, 1, 6, 5, 7, 2]

print("8: rounds: {}".format(rounds(d1, d2, debug=False)))

cards = []
max_card = 13

for i in range(1, max_card + 1):
  cards += [i] * 4

print(cards)

deck = 1

max_count = 0
max_d1 = []
max_d2 = []

while(True):
  perms += 1
  random.shuffle(cards)

  d1 = cards[0:(int)(len(cards)/2)]
  d2 = cards[(int)(len(cards)/2):]

  if (perms % 10000 == 0):
    print("perms: {}".format(perms), end="\r")

  #print("d1: {} ({})".format(d1, len(d1)))
  #print("d2: {} ({})".format(d2, len(d2)))

  round_count = rounds(d1,d2)

  if (round_count > max_count):
    max_count = round_count
    max_d1 = d1
    max_d2 = d2

    print("d1: {}".format(d1))
    print("d2: {}".format(d2))
    print("{}: ROUNDS: {}".format(deck, round_count))

  if (round_count > 6348):
    break

  deck += 1

  