midiclient.init;

~midiout = midiout.newbyname("launchkey 49", "launchkey midi")

~midiout2 = midiout.newbyname("iac driver", "tidal1")

~dirt.soundlibrary.addmidi(\launchkey, ~midiout);

~dirt.soundlibrary.addmidi(\tidal1, ~midiout2);
