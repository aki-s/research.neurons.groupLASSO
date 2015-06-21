About this repository
=====================
* This software can statistically estimate network structure of real neurons from a rat.
  * Data format is the sequence of time series of spikes from a slice data of a brain (calcium imaging).

* This is my first application with more than 100 method files (Mainly MATLAB files), created during 2011-2012 when I was a graduate student
dreaming of becoming a researcher who can do biological experiments and mathematical analysis of the results.
Years have passed when this application had been created and slept on my PC, because
there were secret data provided by the other researcher.

* This time I have decided to publish this application to get better job opportunity
as a software developer to work with supermen (I've already left academic world).
I want to develop my career as a super software developer, though my current job is not suitable for this purpose
(not writing code, no research, small jobs anyone can do.).
My recent worry is I may have no target to develop (though seeking),
so I have no personal software to display on github (Writing software for research was pleasant.), and decided to
upload this one (Better than nothing to show, I think.).

Keywords
========

self-introduction, group-LASSO, neurons, network-structure-estimation, MATLAB

requirements
=====================
+ MATLAB
+ High performance computer (maybe)
+ Input data (the sequence of spikes)

Software details
================
+ The sequence of process of this program
(You know I have not read this software over 3 years and I have no MATLAB. The description bellow is from my memory.)
  + Write a configure file. (Network structure, parameters. Mail address to be notified when program finished.)
  + Run myest.m
  + Output from program is written to a directory.
  + If you had set mail address in the configuration file, mail notification would be sent to you!

+ Other information can be seen
 ./tags/REL-0.2.0b/man/README  # This file seems to be obsolete, but no better than nothing to read.

+ This repository was converted from subversion
 + I believe in myself that I did not do shitty usage of revision control system in my youth.
(This project was a part of my hobby exercise though. personally launched revision control system on my lab, combined with Trac.)



Links
=====

* [paper related this this repository](http://ci.nii.ac.jp/naid/110008605708)
  * [secret data provider](http://www.gaya.jp/ikegaya.htm)
  * [external Library](https://github.com/ryotat/dal/blob/master/README.md)
* [my personality and profile (ja)](https://www.wantedly.com/users/1753941)
* [LinkedIn (en/ja)](http://jp.linkedin.com/pub/syunsuke-aki/36/398/b01)

License
======
* For real data from a rat, ask Yuji Ikegaya http://www.hippocampus.jp/CV/
* For DAL (Dual Augmented Lagrangian), ask https://github.com/ryotat/dal developed by Ryota Tomioka (http://ttic.uchicago.edu/~ryotat/)
* For the other *.m files It's free. (as of 2015/06/21) (Almost all part was developed by me from scratch, I remember.)

Last Updated
------------
2015/06/21 18:00
