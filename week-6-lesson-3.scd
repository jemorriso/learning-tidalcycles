MIDIClient.init;

// ~midiOut = MIDIOut.newByName("launchkey 49", "launchkey midi")

~midiOut = MIDIOut.newByName("IAC Driver", "Tidal1")

// ~dirt.soundlibrary.addmidi(\launchkey, ~midiout);

~dirt.soundLibrary.addMIDI(\tidal1, ~midiOut);
