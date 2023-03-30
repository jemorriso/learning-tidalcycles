## Installation

I used the [automatic installation script](https://tidalcycles.org/docs/getting-started/macos_install)

Then I installed [vim tidal](https://github.com/tidalcycles/vim-tidal)

Had to add to PATH:

- `/Users/jerry/.local/share/nvim/site/pack/packer/start/vim-tidal/bin`
  - in order to do `tidal`
- `/Applications/SuperCollider.app/Contents/MacOS`
  - in order to do `sclang`
- `/Users/jerry/.ghcup/bin`
  - in order to do `cabal` (in order to use tidal, as it is a haskell package)

## Startup

in order to start SuperDirt:
`sclang`
`SuperDirt.start`

Once SuperDirt is running, run `tidal` from command line which is a script provided by [vim tidal](https://github.com/tidalcycles/vim-tidal)

Then use vim tidal / slime to send snippets to the tmux window running the `tidal` command

## Install without the automatic install script
Follow [recommended haskell install](https://www.haskell.org/ghcup/)

Do `brew install --cask supercollider`

Get [latest sc3-plugins version](https://github.com/supercollider/sc3-plugins), unzip, and move `SC3plugins` folder to `/Users/jerry/Library/Application Support/SuperCollider/Extensions/SC3plugins`
> there seem to be a bunch of extra files that supercollider tries to load and errors, but I think it's picking up the plugin files properly as well.

Follow the rest of the manual install process from [tidalcyles](https://tidalcycles.org/docs/getting-started/macos_install/)

Install vim tidal, go to install directory, run `make install`

---

[Forum Index weeks 1 to 4](https://club.tidalcycles.org/t/weeks-1-4-index/395)

## Lesson 2

Discovered the superdirt startup file (nice use of `fd` to find it) here: `/Users/jerry/Library/Application Support/SuperCollider/downloaded-quarks/SuperDirt/superdirt_startup.scd`

Copied it into the SuperCollider startup file here (it was empty before): `/Users/jerry/Library/Application Support/SuperCollider/startup.scd`

I also added a line so that it loads a sample pack stored here: `/Users/jerry/courses/learning-tidalcycles/samples/samples-extra/*`

Now when i run `sclang` it runs the startup file which automatically starts superdirt and loads the sample pack!

## Lesson 3 - Mini Notation

> sequencing babyyyyy

- mini notation is the part of the code that is inside double quotes
- when we add items inside double quotes it cuts up the grid in smaller segments
  - whole note, half note, triplet, quarter note ....

### n-patterns

`d1 $ n "snare:5"` picks the 6th sample from the 'snare' folder
`d1 $ n "0 3 5 2" # sound "kick"` applies the n-pattern to the array of numbers, picks the respective samples from the 'kick' folder

### rests

`d1 $ n "0 ~ 0 ~" # sound "kick"` puts a kick on 1 and 4 only

### subsequences

`d5 $ n "~ 1 ~ [1~~1]" # sound "clap"` in brackets we have 16th notes because there are 4 characters in there

- you can arbitrarily subdivide the steps
  `d5 $ n "~ 1 ~ [[1 1]~~1]" # sound "clap"` puts 2 1's in the space of 1 16th note so it becomes 32nd note

---

## [Lesson 3 - Mini Notation Part 2](./mini-notation-week-part-2.tidal)

### repeating with speeding up

easier than writing lo four times, becomes 8th notes because it's (1/2)/4
`d1 $ sound "hi lo*4"`

16th notes:
`d1 $ sound "hi [hi lo]*4"`

we multiply a subsequence of 2 by 1.5 to get 3. Think of it making a chain of [sd hc sd hc sd hc]... and then chopping it up into 3s so that the
first run is [sd hc sd] and the second run is [hc sd hc] and on and on...
`d1 $ sound "bd [sd hc]*1.5"`

`d1 $ n "[0 3 4*2 0 3]" # sound "cpu2"`
`d1 $ n "[0 3 [4 4] 0 3]" # sound "cpu2"`

- above are the same phrase, so it's like the brackets are implicit

### repeating without speeding up

use `!` instead of `*`

```
d1 $ sound "[lo~]!2"

d2 $ sound "[~hi]!2"
```

makes `lo hi lo hi`

`d1 $ sound "hi lo !"`
single repeat of `lo`

- this also works with subsequences

### slowing down

`d1 $ sound "hi lo/2"`
this actually makes `hi lo | hi ~` because the single event `lo` is split into 2, and since event fires at the beginning it only makes a sound for
the first half

this would make more sense if you used something in brackets
`d1 $ sound "hi [lo lo]/2"`
goes back to `hi lo hi lo`

notice how it's a different rhythm!

`d1 $ s "[clap:4 [lo hi] / 2]*2"`

- quarter notes, alternating lo and hi
- notice how it's multiplied by 2 to make it quarter notes

`d1 $ fast 2 $ s "[clap:4 [lo hi] / 2]"`

- same as above, using `fast` keyword instead of `*2`

`d1 $ n "0 0 0 [0 1 3 4 5 6]/2.5" # sound "cpu2"`

- crazy sounding rhythm that I'm too lazy to figure out right now

### polyphony

use `,` to play things at the same time
`d2 $ sound "[bd!4, [~hh]!4, [~clap:4]!2]"`

- this is kind of a standard 4 to the floor beat
  `d1 $ sound "[bd sn, arpy*3, mt ht lt mt] [clap:6 snare]"`
- concatenated so only the first part is polyphonic

### polymeter

`d1 $ fast 4 $ sound "{bd sd, arpy arpy:4 arpy:5}"

d1 $ fast 4 $ sound "[bd sd, arpy arpy:4 arpy:5]"`

- using curly brackets instead of square ones makes the arpy become a polymeter so it cycles through the 3 notes
- it seems to be mapped onto whatever the first half of the phrase is

### rhythmic feet

- use `.` instead of square brackets to mark out the meter basically

### one step per cycle

`d1 $ fast 3 $ s "hi [arpy arpy:1 arpy:2]/3"

d1 $ fast 3 $ s "hi <arpy arpy:1 arpy:2>"`

- use angle brackets to pick one per cycle
- above patterns do the same thing
- angle brackets are better here because you can add more without needing to divide

---

## [Mini-notation week part 3](./mini-notation-week-part-3.tidal)

### Euclidean notation

- using Euclidean algorithm to generate rhythm
- they don't really go into detail how it works

  - basically the algo tries to divide the rhythm into equal parts and fill in the notes
  - `draw x(3,9)` shows how it works
  - `draw x(3,8)` shows how it doesn't divide evenly
  - so now it's easier to understand what the algo is doing
    `d1 $ sound "clap:1(5,16)"`

- draw the pattern to see what it does
  `draw "x(7,12)"`
- it has 7 notes in 12 steps

- many rhythms can be expressed in Euclidean notation

`draw "x(3,8,1)"`
3rd parameter shifts the pattern 1 left

- there's also the `drawLine` function which does multiple cycles

---

## [week 2 lesson 1 - effects](./week-2-lesson-1.tidal)

[source](https://club.tidalcycles.org/t/week-2-lesson-1-starting-out-with-effects/463)

`d1 $ n "0 0 [3 4] 3" # sound "cpu" # crush "3 16"`
applies the 'crush' effect to the cycle, where the first half has level 3 and then the second half has level 16

### the hash (#) operator

- basically just piping functions

`d1 $ n "0 0 [3 4] 3" # sound "cpu"` applies the 'cpu' sound to each item in the cycle

`d1 $ sound "cpu" # n "0 0 [3 4] 3"` works, but since there's only 1 cpu you only hear the first note, it's basically trying to pattern match i
believe
`d1 $ sound "cpu cpu" # n "0 0 [3 4] 3"` and you hear 0 and 3 because it splits into 2 equal parts
`d1 $ sound "cpu*16" # n "0 0 [3 4] 3"` and you hear 16th notes

> hash operator takes the value on the left and maps it onto the right
> most of the time you put the n-pattern first, because that's where you want the structure to come from

---

## [week 2 lesson 2 - time](./week-2-lesson-2.tidal)

[source](https://tidalcycles.org/docs/patternlib/tutorials/course1/#lesson-2-manipulating-time)

tidal uses 0.5625 cycles per second which works out to 135 bpm ((135 beats / minute) _ (1 minute / 60 seconds) _ (1 cycle / 4 beats) == 0.5625)

### setcps

use `setcps` to change the cycles per second

- it is global so it affects all phrases playing

you can also use `setcps` as an effect and pipe it, but it's still global, so you only need to do it on one thing

- you can even pattern it! so it changes different sections of the phrase

```
d2 $ n "0(3,8) 8*8" # sound "cpu2"
  # squiz 5
  # cps (saw + 0.5)
```

passing `(saw + 0.5)` to the cps so that it's a saw wave from 0.5 to 1.5 over 1 cycle - whenever an event is sent it samples a value from the saw
wave, so the cycle speeds up as it goes

### fast and slow

```
d1 $ slow 2 $ n "0 2 [3 5] [4 7]" # sound "cpu"

d1 $ fast 2 $ n "0 2 [3 5] [4 7]" # sound "cpu"
```

you need the `$` because it has low precedence and we want to pass the result of the RHS to the `fast` function

you can also use parens like so: `d1 $ fast 2 (n "0 2 [3 5] [4 7]" # sound "cpu")`
but the author recommends `$`

the value can also be patterned!!!

```
-- You can also pattern this speed factor:
d1 $ slow "0.5 1" $ n "0 2 [3 5] [4 7]" # sound "cpu"
```

it follows the same patterning logic as elsewhere, apply 0.5 to the first half and 1 to the second half

- see the description [here](https://youtu.be/ARCZE_XLhfk?t=663)
- perfect explanation of the above concept in the forum (see comment by 'heavy.lifting')
  [forum](https://club.tidalcycles.org/t/week-2-lesson-2-manipulating-time-with-setcps-cps-patterns-and-fast-slow-functions/466/4)

the key to understanding the above is imagining that you're layering 2 patterns on top of one another, where the first one is `slow 0.5` and the
second one is `slow 1`, and then each cycle grabbing half from `slow 0.5` and half from `slow 1`, as they both 'run in the background'

---

## [week 2 lesson 3 - combining patterns](./week-2-lesson-3.tidal)

[source](https://tidalcycles.org/docs/patternlib/tutorials/course1/#lesson-3-combining-patterns-with-arithmetic)

### structure and value operators

- `#` is shorthand for `|>`, which means **_structure from left, values from right_**

  - this is why normally we put the n-pattern first and then chain things like sample folders and effects

- see the notes for the other forms of these operators, `|>, <|, |<, >|, |>|, |<|`
  - the angle bracket points to where the values are coming from
  - the side that the pipe is on is where the structure is coming from
  - so in the case of `|>|`, the values are coming from the right, and the structure is coming from both sides

`d1 $ n "0 1 ~ 2" # sound "numbers" # n "4 5"` causes an n-pattern of `4 4 ~ 5`

Everything from the right:
`d1 $ n "0 1 2 3" # sound "numbers" >| n "4 5"`

which is the same as:
`d1 $ sound "numbers" >| n "4 5"`

```
d1 $ speed "1 2 0.5" # sound "dsynth" <| speed "3 4"

d1 $ speed "1 2" # sound "dsynth"
```

these are the same because it's taking the structure from the right, and the 2 is active when the 4 starts

`d1 $ n "0 1 2" # sound "numbers" |>| n "4 5"`
this creates a polyrhythm because it's 3 notes against 2 notes

### combining values

- use `+` operator to add values from both sides together
- we have `|+`, `+|` and `|+|`
- pipe operator has the same function

This:
`d1 $ n "0 1 2 3" # sound "numbers" |+ n "4 5"`

adds up to:
`d1 $ n "4 5 7 8" # sound "numbers"`

- use `*` operator similar to `+` but it multiplies (shocker!!!)

`|*|` === `*` and `|+|` === `+`

- you can leave out the bars if you want to take structure from both sides

### hurry

`hurry` pitches up the sample in addition to making it faster, as opposed to `speed`, which only makes it faster

### control patterns vs. number patterns

`speed`, `sound`, `squiz` are all control patterns that have meanings for the synth, and are sent to the synth, vs number patterns which get attached
to the control patterns

from the worksheet:

```
-- To be clear, this is a pattern of numbers:
-- "7 5 [2 7] 0"

-- This is a control pattern, because 'n' turns numbers into synthesiser
-- control patterns:
-- n "7 5 [2 7] 0"
```

you can also use parens to apply arithmetic directly to the number patterns

---

## [week 3 lesson 1 - the 'every' function](./week-3-lesson-1.tidal)

[source](https://tidalcycles.org/docs/patternlib/tutorials/course1/#lesson-3-combining-patterns-with-arithmetic)

### the 'every' function

`every n (fn) $ fn 2` where _n_ is an integer to do the thing in the parens every n times to the second function

`d1 $ every 3 (fast 2) $ sound "bd sd ~ cp"`
note that it doesn't change the cycle length, the last cycle has the pattern run twice instead

the above is the common pattern with the dollar sign at the end, for the last input

we can chain `every` functions:
`d1 $ every 2 (hurry 2) $ every 3 (# squiz 5) $ sound "bd sd [~ bd] [cp bd*2]"`

also note that we're using `squiz` inside parens, where the final pattern is implicitly being passed to the left of the `#`, at least that's the way
I'm understanding it right now...

in general, it's evaluating from right to left, like a curried function which i think is actually what it is (?)

> **_tidal evaluates chained patterns from right to left_**

these are the same:

```
d1 $ every 3 (fast 2) (sound "bd sd ~ cp")

d1 $ every 3 (fast 2) $ sound "bd sd ~ cp"

```

but this doesn't work:

```
-- This saves you from having to match up ( and ) around a function's
-- final input. It doesn't work with anything other than the final
-- input, so unfortunately this _doesn't_ work

d1 $ every 3 $ fast 2 $ sound "bd sd ~ cp"
```

it doesn't work because the `every` function doesn't understand the _result_ of `fast 2 $ sound "bd sd ~ cp"`, it only knows how to handle a pattern
like `fast 2`

---

## [week 3 lesson 2 - cut vs legato](./week-3-lesson-2.tidal)

[source](https://tidalcycles.org/docs/patternlib/tutorials/course1/#lesson-2-cut-vs-legato)

### cut groups

`d1 $ fast 2.5 $ sound "ho:4 hc ho:4 hc" # cut 1`

cuts off the tail of the open hi-hat

### cut vs legato

```
d1 $ sound "sax(3,8)" # cut 1

d1 $ sound "sax(3,8)" # legato 1
```

`cut` makes the samples fill the space between the notes, while legato cuts them off at the end of the note lined up to the grid

- also, when you `hush`, `cut` will have the note ring out but legato obviously won't because it will already have been cut off

legato can be more useful because it is more predictable

---

## [week 3 lesson 3 - slice and splice](./week-3-lesson-3.tidal)

[source](https://tidalcycles.org/docs/patternlib/tutorials/course1/#lesson-3-slice-and-splice)

`d1 $ splice 8 "0 1 2 3 4 5 6 7" $ sound "break:4"`
he doesn't really explain it but I think what it does is split the sample into 8 parts, and then play those 8 parts back to back. If you listen to
the sample without splicing, it doesn't loop on a grid properly, somehow this makes it work... does it know when the beat is in the sample? That
doesn't make sense.

`slice` is the same without pitch-shifting coming from stretching or squeezing the chops, so the rhythm can go a little bit off at different speeds

---

## [week 3 lesson 4 - chop and striate](./week-3-lesson-4.tidal)

[source](https://tidalcycles.org/docs/patternlib/tutorials/course1/#lesson-4-chop-and-striate)


### once
`once $ sound "break:8"`
simply plays the sample one time

### begin
`d1 $ sound "break:8*4" # begin 0.75 # end 1`
plays the last quarter of the break 4 times

### unit
change behaviour of `speed` so that it matches the *cps*
- at least that's what `unit "c"` does
`d1 $ sound "break:8*4" # speed 1 # unit "c" # begin 0.75 # end 1`

`chop` and `striate` help manage the above automatically: `begin`, `unit` and `end`

### loopAt
`loopAt` sets where to loop on the cycle - if `loopAt` is set to 2 your loop will run once every two cycles, effectively halving the tempo

`d1 $ slow 2 $ loopAt 2 $ chop 4 $ sound "break:8 break:9"`
here we're slowing by 2 in order to make room for both sounds...
`d1 $ loopAt 2 $ chop 4 $ sound "break:8 break:9"`
makes the chopped bits trigger overlapping which we obviously don't want

### chop
`chop` simply chops the sample in parts, which you can then do what you want with them, but I guess the thing is that they are in order

### striate
`striate` interweaves the sounds, layering them on top of one another

`d1 $ slow 2 $ loopAt 2 $ striate 4 $ sound "break:8 break:9"`
cuts it into 8 parts, 4 per sound, and then plays 1a,2a,1b,2b,3a,3b,4a,4b
- again we need to slow by 2 to fit all the sounds in

`d1 $ slow 4 $ loopAt 1 $ striate 2 $ sound "break:1*4"`
repetition of 4 over each striation

---

## [week 4 lesson 1 - continuous patterns and random functions](./week-4-lesson-1.tidal)

[source](https://tidalcycles.org/docs/patternlib/tutorials/course1/#lesson-1-continous-patterns-and-random-functions)

> continuous functions cannot be used as structure because no trigger messages are sent to superdirt
so if you want to use continuous function, you can use it as values or do something called *sample-and-hold*

### segment
sample values from a continuous function so we can use it as structure:
`d1 $ speed (segment 32 $ range 0.5 2.5 sine) # sound "bd"`

`d1 $ speed (range 0.5 1.5 sine) # sound "bd"`
does not work

### struct
define some structure to sample from the continuous function:
`d1 $ speed (struct "t(3,8)" $ slow 2 $ range 0.5 2.5 sine) # sound "bd"`
here `t(3,8)` means a boolean array in the `(3,8)` Euclidean pattern, where 3/8 are true and the rest false
- you could do `f(3,8)` as well or even `<f t>(3,8)`

you can use patterns:
`d1 $ speed (struct "t [t f] [f t] t" $ slow 2 $ range 0.5 2.5 sine) # sound "bd"`

### sine
we can apply `sine` to patterns to make a sine wave - very cool what you can do
- `sine`s amplitude is between 0 and 1

`d1 $ sound "bd*32" # speed (sine + 0.5)`
do this to make it between 0.5 and 1.5 (avoid speed 0)

### square, sine, saw, tri
different waveforms

### range
`d1 $ sound "bd*32" # speed (range 0.5 1.5 sine)`
achieves the same as above

### rand
`rand` is a continuous function that returns random values:
`d1 $ sound "bd(5,8)" # speed (range 1 3 rand)`

`d1 $ sound "bd*32" # speed (range 1 3 rand)`
sounds like a motorboat! Note that the pitch is changing because the sample speed changes, but the *structure comes from the left* so it's always
32nd notes

### perlin
similar to `rand`, but smoothly transitions between random values each cycle
`d1 $ sound "bd(5,8)" # speed (range 1 3 perlin)`

### room
reverb.
```
d1 $ sound "clap:4*4"
# room 0.7
# sz (slow 4 saw)
```
here we're passing a slow saw wave to `sz` in order to modulate reverb!

### sz
define the "size of the room" for reverb

---

## [week 4 lesson 2 - random marathon part 1](./week-4-lesson-2.tidal)

[source](https://tidalcycles.org/docs/patternlib/tutorials/course1/#lesson-2-random-marathon-part-i)

### rand
function `rand` gives values between 0 and 1, so you can shape the random number range you want using arithmetic
- it is a *continuous* function, but a *deterministic* function of the clock as a matter of fact

### resetCycles
- resets cycle count to zero, as though you have just started tidal - so if you do this again with the same random function, you will see that it is deterministic

### repeatCycles
repeat a cycle *n* times
- do this with `rand` so that you get a new random pattern every *n* cycles
- this is helpful to latch onto some repetition

### irand
pick randomly from a set of integers
`d2 $ n (struct "t(5,8)" $ (irand 8) + 24) # sound "rash"`
generates a random sequence of integers between 24 and 32

### using Mini-notation
#### the `|` operator
pick randomly from a set of subsequences in an n-pattern
```
d1 $ n "0 [0|1*3|2*8|3 4 5] 2 3" # sound "cpu"
   # speed 1.5
```
#### the `?` operator
randomly drop an event
```d1 $ sound "bd bd bd clap?"```
with 50/50 probability

```d1 $ sound "bd bd bd clap?0.1"```
0.1 probability of dropping the clap

```d1 $ sound "bd bd bd bd*8?0.2"```
applied vector-wise, so that each event in the sequence has 0.2 prob of being dropped

### scramble
divide pattern into `n` parts, and then pick them at random
```
d1 $ scramble 4 $ n "0 1 2 3 4 5 6 7" # sound "arpy"
   # room 0.3 # sz 0.8
```
here the 4 parts are (0,1),(2,3),(4,5),(6,7)

I can see this being useful for this particular case, chopping up an arpeggio

### shuffle
divide pattern into `n` parts, and then shuffle them, such that each part is played once per cycle

### choose
pick between single values
- function is continuous so you need to give it structure
- any structure will work... euclidean, etc.

```d1 $ sound (segment 8 $ choose ["bd", "arpy", "snare"])```

### wchoose
weighted choose
```d1 $ sound "clap*4" # speed (wchoose [(2, 4), (-2, 2)])```
choose speed 2 with weight 4, -2 with weight 2 (half as likely)
- note that *negative speed* makes the sample play in reverse!

### randomness in tidal
is deterministic - derived from the clock. So if we use `rand` function twice, the two things being randomized get the same random numbers at the same times.
```d1 $ sound "clap*2" # speed (range 0.1 2 rand) # pan rand```
here you can hear that when `rand` is low, the clap is low in pitch and panned to the left, and vice versa for high `rand`

```
d1 $ sound "clap*2" # speed (range 0.1 2 rand)
  # pan (slow 1.001 rand)
```
here we slow one of the patterns down so that now they are completely uncorrelated

---

## [week 4 lesson 3 - random marathon part 2](./week-4-lesson-3.tidal)

[source](https://tidalcycles.org/docs/patternlib/tutorials/course1/#lesson-2-random-marathon-part-i)

### cat
concatenate patterns together
```d1 $ sound (cat ["kick snare:4 [~ kick] snare:5", "kick snare:4 . hc(5,8)"])```

### randcat
concatenate them in a random order
```d1 $ sound (randcat ["kick snare:4 [~ kick] snare:5", "kick snare:4 . hc(5,8)"])```

```
d1 $ vowel (randcat ["a e*2 i o", "e o u", "o*8"])
   # sound ("kick snare:4 clap:4")
```
notice how the randomly chosen pattern is used as the structure and the sound gets mapped onto it
> seems like it doesn't always pick one of each though... in which case why do you need to concatenate? Why not just `choose`?

### wrandcat
weighted `randcat`

```
d1 $ sound (wrandcat [("bd sn:4(3,8)", 100),
                      ("arpy clap", 0.5),
                      ("cpu(5,8)", 0.25)
                     ]
           )
```
picks the first pattern over and over. So not seeing the difference between `wchoose` and `wrandcat` here...

### stripe
`stripe n` divides the cycle into `n` parts randomly, and then plays `n` repetitions
```
d1 $ stripe 2 $ n "0 4*2 ~ 4 2 4 5 ~" # sound "cpu2"
  # squiz 2
  ```
e.g. random number 0.75 is chosen, the first cycle takes up 0.75 cycles and the second one takes up 0.25

### degrade
```
d1 $ sound "bd*8?"

-- Degrade is a function that does the same:
d1 $ degrade $ sound "bd*8"
```
i.e. it randomly drops out notes like the `?` mini-notation syntax

### degradeby
weighted `degrade`
```d1 $ degradeBy 0.6 $ sound "bd*8"```
60% chance of dropping a note

### sometimes
apply function only sometimes
```d1 $ sometimes (# crush 4) $ n "0 ~ 3 1 5 2 ~ 5" # sound "cpu"```
note that it occurs within cycle - here `crush` may be applied for some sections and then not for other sections within one cycle

### sometimesBy
weighted `sometimes`
```d1 $ sometimesBy 0.3 (# crush 4) $ n "0 ~ 3 1 5 2 ~ 5" # sound "cpu"```

### other frequencies
```
-- There's some aliases for different probabilities:

{-
sometimes = sometimesBy 0.5
often = sometimesBy 0.75
rarely = sometimesBy 0.25
almostNever = sometimesBy 0.1
almostAlways = sometimesBy 0.9
-}
```

### somecycles
randomly apply to cycles rather than individual events within the cycle
```
d1 $ somecycles (hurry 2) $ n "0 ~ 3 1 5 2 ~ 5" # sound "cpu"
  # speed 1.5
  ```

### somecyclesBy
weighted `somecycles`

### randslice
take a random chunk of the beat and play 1 event at the beginning of the cycle
```d1 $ randslice 4 $ sound "break:8"```
plays 1 quarter of the break (so there are then 3 quarter notes of silence)

```d1 $ loopAt 1 $ randslice 4 $ sound "break:8*4"```
now it fits 4 quarter notes into 1 cycle

still not totally sure what `loopAt` is doing... I think it packs the quarter notes into 1 cycle

```d1 $ splice 4 (segment 4 $ irand 4) $ sound "break:8"```
Another way of achieving random break chopping... here we segment the break into 4 parts, pick randomly amongst them, and then play 1 after the other with `splice 4`

---

## [week 5 lesson 1 - musical notes](./week-5-lesson-1.tidal)

[source](https://tidalcycles.org/docs/patternlib/tutorials/course2#lesson-1-musical-notes)

### note
`note "3"` prints out the information about the first cycle, given the note pattern. Use `note` in addition to `drawLine`

```
tidal> note "3"
(0>1)|note: 3.0n (ds5)
tidal> note "0"
(0>1)|note: 0.0n (c5)
tidal> note "0 ~"
(0>½)|note: 0.0n (c5)
```

I thought `note "0"` would be middle C (c4)? Well he says it is middle c but it's c5 for some reason.

Note that it also shows the rhythm of the note as shown on the last line.

Depending on the instrument you are using, you can use non-integer notes:
`d1 $ note "12.34" # sound "supermandolin"`

### sharps and flats
```
-- This:

note "a b c d e f g"

-- is the same as:

note "9 11 0 2 4 5 7"

-- What happened to 1, 3, 6, 8, and 10?
-- You can get to them by adding 's' for 'sharp', to add 1 to a note:

note "cs ds fs gs as"

-- or by using 'f' for 'flat' to subtract 1:

note "df ef gf af bf"
```

`d1 $ note "csssssss g" # s "superpiano"`
these are the same

To get different octaves:
`note "c5 c6 c4 c6"`

These are the same:
```
d1 $ n "c a f e" # s "superpiano"

d1 $ note "c a f e" # s "superpiano"
```

Note how we use n-patterns for samples as well as synthesizers!

But it means something different for samples:
```
-- For samples, they mean something different. 'n' chooses a sample,
-- 'note' plays it at a different speed, corresponding to a note.

-- Different sounds:
d1 $ n "0 1" # sound "dsynth"

-- Different notes:
d1 $ note "0 1" # sound "dsynth"
```
Need to be careful if using note *letters* with samples, because letters are just aliases for numbers - then it's just picking the numbered sample!

Using both together:
```
-- The 'dbass' sample has three bass sounds, again in 'c', of
-- different lengths.  So it makes sense to use *both* 'note' and 'n'
-- together, to pattern both the pitch and the sample that's used:
d1 $ note "c a f e" # sound "dbass" # n "<0 1 2>"
```

### octave
jump up and down by 12
```
-- There's also an 'octave' control to jump up/down in twelves:
d1 $ note "c a f e" # sound "superpiano"
  # octave "<4 6 3>"
```
---

## [week 5 lesson 2 - musical notes](./week-5-lesson-2.tidal)

[source](https://tidalcycles.org/docs/patternlib/tutorials/course2/#lesson-2-chords-arpeggios-and-algoraoke)

### playing chords
```d1 $ n "c'maj e'maj" # sound "supermandolin"```
alias for `c'maj` is just `'maj`. c is default

these are the same:
```
d1 $ arpeggiate $ n "c'maj" # s "superpiano"

d1 $ arpeggiate $ n "c'maj'3" # s "superpiano"
```
the reason is the 2nd says play the first 3 notes of the c chord

`d1 $ arpeggiate $ n "c'maj'7" # s "superpiano"`
this will play c chord, then c chord of higher octave, then finally c note of 2x high octave

these are the same:
```
d1 $ n "c'sevenFlat9 a'm9sharp5" # sound "supermandolin"

d1 $ n "[0,4,7,10,13] [9,10,23]" # sound "supermandolin"
```
because everything in the chord gets turned into numbers!

### arpeggiate
`d1 $ arpeggiate $ n "c'maj'4 e'min7'4" # s "superpiano"`

### arp
`arp` is more flexible because you can specify the pattern in which the chord is arpeggiated
```
d1 $ arp "updown thumbup" $ n "<c'maj'4 e'min7'4>" # s "superpiano"

-- Here's the list of currently available arp styles to explore:
-- up, down, updown, downup, converge, diverge, disconverge, pinkyup,
-- pinkyupdown, thumbup thumbupdown
```

---

## [week 5 lesson 3 - adding superdirt synths](./week-5-lesson-3.tidal)

[source](https://tidalcycles.org/docs/patternlib/tutorials/course2/#lesson-3-adding-and-using-superdirt-synths)

I cloned [this repo](https://github.com/diegodorado/tidal-synths), then copied the code for the synth `cs80lead` into the `sclang` repl. That loads the synth and allows you to call it from tidal: `d1 $ sound "cs80lead"`

Then you can run effects on the synth in tidal as normal:
`d1 $ n "c5" # sound "cs80lead" # crush 3 # room 0.2 # sz 0.6`

### modifying the synth
sounds like there is something wrong with the envelope, apparently because superdirt takes care of the envelopes... so we can remove the envelopes from the synth ??

`d1 $ n "c5" # sound "cs80lead" # crush 3 # room 0.2 # sz 0.6 # vowel "a e" # pF "dtune" "<1 0.2>"`
here `pF` means parameter of type floating point - `dtune` is an effect on the supercollider synth, so using `pF` allows us to pattern it in tidal!

We can do `dtune = pF "dtune"` and then use `dtune` as a variable.

Better yet, we can add it to my tidal boot script:
`~.cabal/share/aarch64-osx-ghc-9.2.5/tidal-1.9.4/BootTidal.hs`

so that it's always available on tidal startup.

Then we can do the same with the synth, copying our `cs80lead` code into the supercollider startup file.

---

## [week 5 lesson 4 - superdirt part 2](./week-5-lesson-4.tidal)

[source](https://tidalcycles.org/docs/patternlib/tutorials/course2/#lesson-4-superdirt-part-ii)
