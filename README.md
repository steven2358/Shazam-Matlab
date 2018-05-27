Shazam-Matlab
===

A small Matlab implementation of the Shazam music recognition algorithm by Dr. Avery Wang.

Code written for the 2005 blog post [Shazam@home](http://squobble.blogspot.com/2005/04/shazamhome.html).

Author: Steven Van Vaerenbergh.

Preliminaries
---

This package requires a directory containing music or audio fragments in `.wav` format.

Part A: Feature extraction
---

1. Open `local_settings_sample.m`, fill in the `songdir` and `hashdir` of your choice and save as `local_settings.m`. The `hashdir` can be any directory and must be created manually. The `songdir` must contain audio fragments in .wav format, mono, and sampling frequency preferably 8kHz. For music recognition, each audio fragment is a complete song.
2. Run `extract_features.m`. This creates a hashtable for each song, in a `.mat` file. For details, see the explanation by Dr. Wang.

Part B: Music recognition
---

Test 1 - Run `tag_test.m`: This file takes a piece of test music, adds noise and tries to recognize it by matching it to the hashtables.

Test 2 - Run `tagmix_test.m` (experimental): This file mixes fragments of 2 songs and tries to recognize both.

Future improvements
---
- hash table structure can be optimized for speed (single file, tree structure?). Current hashtable is very basic.
- remove dependency on fixed sample frequency. Audio fragments should have arbitrary `fs`.

Disclaimer
---

The code in this package should be used for academic purposes only. The author cannot be held liable for any side effects of using this package.
