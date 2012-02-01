#!/usr/bin/env python
#
# ascii command-line progress bar with percentage and elapsed time display
# 
# adapted from Pylot source code (original by Vasil Vangelovski)
# modified by Corey Goldberg - 2010



class ProgressBar:
    def __init__(self, duration):
        self.duration = duration
        self.prog_bar = '[]'
        self.fill_char = '#'
        self.width = 40
        self.__update_amount(0)
    
    def __update_amount(self, new_amount):
        percent_done = int(round((new_amount / 100.0) * 100.0))
        all_full = self.width - 2
        num_hashes = int(round((percent_done / 100.0) * all_full))
        self.prog_bar = '[' + self.fill_char * num_hashes + ' ' * (all_full - num_hashes) + ']'
        pct_place = (len(self.prog_bar) / 2) - len(str(percent_done))
        pct_string = '%i%%' % percent_done
        self.prog_bar = self.prog_bar[0:pct_place] + \
            (pct_string + self.prog_bar[pct_place + len(pct_string):])
        
    def update_time(self, elapsed_secs):
        self.__update_amount((elapsed_secs / float(self.duration)) * 100.0)
        self.prog_bar += '  %ds/%ss' % (elapsed_secs, self.duration)
        
    def __str__(self):
        return str(self.prog_bar)
        
        
        
if __name__ == '__main__':
    p = ProgressBar(60)
    
    p.update_time(15)
    print p
    
    p.fill_char = '='
    p.update_time(40)
    print p