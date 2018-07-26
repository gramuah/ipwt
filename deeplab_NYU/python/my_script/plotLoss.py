#!/usr/bin/env python

'''
Created on Jan 5, 2016

@author: Daniel Onoro Rubio
'''

import numpy as np
import matplotlib.pyplot as plt
import sys

key = ", loss ="
key2 = " #2: accuracy ="

if __name__ == '__main__':
    log_file = sys.argv[1]
    
    print "Processing log file: ", log_file
    loss_v = []
    it_v = []
    loss_v2 = []
    
    with open(log_file,'r') as f:
        a = 0
        jump = 20
        for line in f:
            if key in line:
                s = line.split(' ')

                a += jump
                it_v.append( int(a) )
                if (len(s) == 9):
                    loss_v.append( float( s[8].strip()) )
                else:
                    loss_v.append( float( s[len(s)-1].strip()) )
            if key2 in line:
                ss = line.split(' ') 
                loss_v2.append( float(ss[14].strip()) )
    print len(loss_v2), len(it_v)
    print loss_v2
             
    plt.plot(it_v, loss_v, linewidth=2.0)
    #plt.plot(it_v[1:5000], loss_v2[1:5000], linewidth=2.0)
    plt.xlabel("Iterations")
    plt.ylabel("Loss")
    
    plt.axis([1, 200, 0, 2.5])
    plt.grid(True)
    plt.show()
