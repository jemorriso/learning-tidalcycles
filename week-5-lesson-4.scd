SuperDirt.start;

SynthDef(\test, {
  |out,sustain=1,freq=440,speed=1,begin=0,end=1,pan,accelerate,offset|
  var tone = SinOsc.ar(freq);
  var env = Line.ar(1,0,sustain, doneAction: Done.freeSelf);
  var outAudio = tone*env;

  OffsetOut.ar(out,[outAudio, outAudio]);
}).add;

SynthDef(\test2, {
  |out,sustain=1,freq=440,speed=1,begin=0,end=1,pan,accelerate,offset|
  var env = Line.ar(1,0,sustain, doneAction: Done.freeSelf);
  var tone = Pulse.ar(freq, env);
  var outAudio = tone*env;

  OffsetOut.ar(out,[outAudio, outAudio]);
}).add;

SynthDef(\test3, {
  |out,sustain=1,freq=440,speed=1,begin=0,end=1,pan,accelerate,offset|
  var line = Line.ar(begin,end,sustain, doneAction: Done.freeSelf);
  var env = Env.new(levels: [0, 1, 0.9, 0], times: [0.1, 0.5, 1], curve: [-5, 0, -5]);
  var volume = IEnvGen.ar(env, line);
  var tone = Pulse.ar(freq, line);
  var outAudio = tone*volume;

  OffsetOut.ar(out,[outAudio, outAudio]);
}).add;

SynthDef(\test3, {
  |out,sustain=1,freq=440,speed=1,begin=0,end=1,pan,accelerate,offset|
  var line = Line.ar(begin,end,sustain, doneAction: Done.freeSelf);
  var env = Env.new(levels: [0, 1, 0.9, 0], times: [0.1, 0.5, 1], curve: [-5, 0, -5]);
  var volume = IEnvGen.ar(env, line);
  var tone = Pulse.ar(freq, line);
  var outAudio = tone*volume;

  OffsetOut.ar(out,DirtPan.ar(outAudio, ~dirt.numChannels, pan, volume));
}).add;

SynthDef(\test4, {
  |out,sustain=1,freq=440,speed=1,begin=0,end=1,pan,accelerate,offset,clamp|
  var line = Line.ar(begin,end,sustain, doneAction: Done.freeSelf);
  var env = Env.new(levels: [0, 1, 0.9, 0], times: [0.1, 0.5, 1], curve: [-5, 0, -5]);
  var volume = IEnvGen.ar(env, line);
  var tone = Pulse.ar(freq, line);
  // 20000 kHz is ~ limit of human hearing
  var outAudio = RLPF.ar(tone*volume, 20000*clamp*volume,0.1);

  OffsetOut.ar(out,DirtPan.ar(outAudio, ~dirt.numChannels, pan, volume));
}).add;

// for some reason it won't compile 😥 - the idea is detuning the sound
SynthDef(\test5, {
  |out,sustain=1,freq=440,speed=1,begin=0,end=1,pan,accelerate,offset,clamp|
  var line = Line.ar(begin,end,sustain, doneAction: Done.freeSelf);
  var env = Env.new(levels: [0, 1, 0.9, 0], times: [0.1, 0.5, 1], curve: [-5, 0, -5]);
  var volume = IEnvGen.ar(env, line);
  // divide by 3 so as not to make the sound much louder
  var tone = (Pulse.ar(freq*1.02, line) + (Pulse.ar(freq*0.98, line) + (Pulse.ar(freq, line)) / 3;
  // 20000 kHz is ~ limit of human hearing
  var outAudio = RLPF.ar(tone*volume, 20000*clamp*volume,0.1);

  OffsetOut.ar(out,DirtPan.ar(outAudio, ~dirt.numChannels, pan, volume));
}).add;

// again it won't compile but the idea is to pass in different speeds from tidal
// then it's acting like a sample (higher pitch when sped up)
// e.g. `d1 $ s "test*2" * gain 0.9 * speed 2`
SynthDef(\test5, {
  |out,sustain=1,freq=440,speed=1,begin=0,end=1,pan,accelerate,offset,clamp|
  var line, env, volume, tone, outAudio;
  freq = freq*speed;
  line = Line.ar(begin,end,sustain/speed, doneAction: Done.freeSelf);
  env = Env.new(levels: [0, 1, 0.9, 0], times: [0.1, 0.5, 1], curve: [-5, 0, -5]);
  volume = IEnvGen.ar(env, line);
  tone = (Pulse.ar(freq*1.02, line) + (Pulse.ar(freq*0.98, line) + (Pulse.ar(freq, line)) / 3;
  outAudio = RLPF.ar(tone*volume, 20000*clamp*volume,0.1);

  OffsetOut.ar(out,DirtPan.ar(outAudio, ~dirt.numChannels, pan, volume));
}).add;
