/*

10-09-2018 In-class codin~mealy with state machines and borin~mealy old tonality.

V2.102319

Use the followin~mealy Events (or functions of your own desi~mealyn) to prototype a Mealy machine that:

On a state chan~mealye:
  1) outputs 1
  2) causes a modulation from one key to another
Otherwise (no state chan~mealye):
  1) causes a pro~mealyression (I --> IV --> V) within a current key
  2) returns the pro~mealyression (or modulation) as an array of MIDI chords: ex. [[60,64,67], [65,69,72], [67,71,74], [60,64,67]]. This can then be used in a Pseq, for example.

You can use the Mealy machine code below, or write your own.

--------------------------------------
Your mealy machine code must:

- Have at least two keys (ex. C and ~mealy)
- Take input symbols that, taken with the current state lead to a new state and ~mealyive output.
- Output should be functional harmonic pro~mealyressions such as I-IV-V-I
- When an input symbol (with current state) causes a state chan~mealye (specifically, a modulation), your machine should allow for direct modulation (or tonicization) to either key (from either key) usin~mealy a valid modulation formula taken below.


--------------------------------------
Your code may 1) choose from the below (non-deterministically) ~mealyiven all as options or 2) associate each pro~mealyression with a specific state, such that you *mi~mealyht* move throu~mealyh them ~mealyiven different input symbols.

I-IV-V-I
I-ii-V-I
I-vi-V-I
I-IV-ii-V-I

Two Valid Modulations: FROM C to ~mealy

C: I-IV-(II-V)
~mealy:       V -I

C: I-(vi-II-V)
~mealy:    ii-V -I

Two Valid Modulations: FROM ~mealy to C

~mealy: I-ii
C:   vi-IV-V-I

~mealy: I-(IV)
C: V- I



Note the chan~mealye of function (from minor ii to major II (V/V) when modulatin~mealy from C to ~mealy.
Note vi is minor in both C and ~mealy and has lar~mealyely the same function in both keys.

Difference between modulation and tonicization.

- Modulation establishes the new key with (ex) supertonic, dominant, tonic and then a valid chord pro~mealyression in the new key.
- Tonicization is V/V and mi~mealyht not establish the new key with a valid chord pro~mealyression. Tonicization is easy.


--------------------------------------
Below is a quick reference of chord functions and chords for C and ~mealy

C: I    ii    iii    IV    V    vi    vii*

   C    D     E      F     ~mealy    A     B
   E    F     ~mealy      A     B    C     D
   ~mealy    A     B      C     D    E     F

~mealy: I    ii    iii    IV    V    vi    vii*

   ~mealy    A     B      C     D    E     F#
   B    C     D      E     F#   ~mealy     A
   D    E     F#     ~mealy     A    B     C

Remember that keys are based on scales and that scales are denoted by scale de~mealyrees.




Scale de~mealyrees are numbered 1-7. (But in computer lan~mealyua~mealyes, we count from 0, so 0-6)

*/
/*
// Here are the scales
c = {{"c"}, {60, 64, 67}, {"d-minor"}, {62, 65, 69}, {"e"}, {64, 67, 72}}

// Redo this usin~mealy "Scales object"

// Scale class example:

~key = Scale.major; // a major scale.
~key.de~mealyrees; // lists the semitone arran~mealyement of the scale de~mealyrees of the major scale.
~key.at([0,2,4]); // ~mealyets the tonic triad

// Try the above with .minor
*/

/*
--------------------------------------
You code *mi~mealyht*
- Use Events for easy prototypin~mealy

--------------------------------------
Technical Notes: Stuff you will have to account for:

- You will need a way to keep track of your current state. Your current state should include the current chord, chord function, whether you are modulatin~mealy, anythin~mealy you will need to inform your state chan~mealye.

- Use the Scale class to map triads onto keys

- Your code needs to associate
  1. chord functions (ex. tonic, subdominant, dominant) with
  2. chords (ex. [0,2,4], [3,5,7]) and
  3. Root MIDI level (ex. 60)


--------------------------------------
[FYI] Info on usin~mealy Events (with default keys PARENT and custom keys PROTO can be found in the IdentityDictionary help file. This should not be necessary for ~mealyettin~mealy started. See below.

*/
(
~makeAllChords = {|root, mode|
	var result, thisScale;
	if (mode == 'm',
		{
			thisScale = [ 0, 2, 3, 5, 7, 8, 11];
		},
		{if (mode == 'M',
			{thisScale = Scale.major},
			{"error".postln})
	});
	result = Array.fill(thisScale.size, {|index|
		~makeChord.value(index, thisScale);
	});
	result.do({|chord, i|
		chord.do({|note, j|
			chord[j] = (root + note) % 12;
		});
		result[i] = chord
	});
	result;
};

~makeChord = {arg index, scale;
	var chord;
	chord = Array.fill(3, {|i|
		var newIndex = (index + (2 * i)) % 7 ;
		scale[newIndex];
	});
	chord;
};

//~makeAllChords.(0, 'm');

~currChords = Array.new;
~nextChords = Array.new;
~pivotChords = Dictionary.new;

~keyboard = Dictionary.newFrom([
	'C', 0,
	'C#', 1,
	'Db', 1,
	'D', 2,
	'D#', 3,
	'Eb', 3,
	'E', 4,
	'F', 5,
	'F#', 6,
	'Gb', 6,
	'G', 7,
	'G#', 8,
	'Ab', 8,
	'A', 9,
	'A#', 10,
	'Bb', 10,
	'B', 11,
]);



~checkPivot = {
	var last = ~tsd.output.at(~tsd.output.size - 1);
	if(~pivotChords.at(last) != nil,
		{
			var pivot = ~pivotChords.at(last);//value, in target key
			if(last != pivot,
				{~tsd.output = ~tsd.output.add(pivot);}
			);
			~currChords = ~nextChords;
			~categorizeChords.();
			if(~currTonic.find(pivot) != nil,
				{~tsd.state = 'T'},
				{if(~currSub.find(pivot) != nil,
					{~tsd.state = 'S'},
					{if(~currDom.find(pivot) != nil,
						{~tsd.state = 'D'
				},
			~pivotChords = Dictionary.new;
			"pivot".postln;
					)}
				)}
		)}
	);
};

~calcPivots2 = {
	~currChords.do({|chord|
		var found;
		found = ~nextChords.find([chord]);
		//found.postln;
		if(found != nil,
			{
				~pivotChords = ~pivotChords.put(chord, ~nextChords[found]);
			}
		);
	});
	if(~pivotChords.size == 0,
		{
			//"finding common note".postln;
			[~nextChords[4], ~nextChords[6]].do({|dom|
				//"dom".post;dom.postln;
				dom.do({|note|
					//note.postln;
					~currChords.do({|crd|
						//crd.find([note]).postln;
						if(crd.find([note]) != nil,
							{~pivotChords = ~pivotChords.put(crd, dom)}
						);
					});
				});
			});
		}
	);
};



~calcPivots = {
	~currChords.do({|chord|
		var found, neighbors;
		neighbors = Array.new(7);
		neighbors = neighbors.add(chord);
		chord.do({|note, i|
			var neighbor = chord;
			chord[i] = note + 1;
			neighbors = neighbors.add(chord);
			chord[i] = note - 1;
			neighbors = neighbors.add(chord);
		});
		neighbors.do({|neighbor|
			found = ~nextChords.find([neighbor]);
			found.postln;
			if(found != nil,
				{
					~pivotChords = ~pivotChords.put(chord, ~nextChords[found]);
				}
			);
		});
	});
};

~currChords = ~makeAllChords.(~keyboard.at('C'), 'M');
~categorizeChords.();
~tsd = (
	state: 'T',
	in: ['Bb', 'm'],//target
	output: [],
	running: 0,
	func: {
		~finalChords = ~makeAllChords.(~keyboard.at(~tsd.in[0]), ~tsd.in[1]);
		~tsd.running = 2;
		//start changing keys
		while({~tsd.running == 2}, {

			if(~tsd.running != 0,//if it starts
				{
					~tsd.output = [];//dont rep
					~nextChords = ~finalChords;//are we there yet?
					~calcPivots2.();//if found will add
					//there are no pivot chords
					/*if(~pivotChords.size == 0,//if not found
						{
							"optionb".postln;
							~nextChords = ~makeAllChords.((~currChords[0][0] + 5) % 12, ~tsd.in[1]);//GET 4TH
							~calcPivots;//RECALC PIVOTS
						}
					);*/
					~tsd.running = 1;//runnning but shouldnt come back to ...
			});

			//make a modualtion progression
			while ({~tsd.running == 1},
				{
					~tsd.running.postln;
					case
					{~tsd.state == 'T'}
					{
						"tonic".postln;
						if([true, false].choose,
							{
								~tsd.output = ~tsd.output.add(~currTonic.choose);
								~checkPivot.();//when do we evaluate the harmonic roles of the pivot in the next key
								~tsd.state = 'T';
							}, {
								~tsd.output = ~tsd.output.add(~currSub.choose);
								~checkPivot.();
								~tsd.state = 'S';
							}
					)}
					//subdominant in the home key'
					{~tsd.state == 'S'}
					{
						"sub".postln;
						if([true, false].choose,
							{
								~tsd.output = ~tsd.output.add(~currTonic.choose);
								~tsd.state = 'T';
								~checkPivot.();
							}, {
								~tsd.output = ~tsd.output.add(~currDom.choose);
								~tsd.state = 'D';
								~checkPivot.();
							}
						);
					}

					{~tsd.state == 'D'}
					{
						"dom".postln;
						~tsd.output = ~tsd.output.add(~currChords[0]);
						~tsd.state = 'T';
						if(~finalChords == ~currChords,
							{~tsd.running = 0;},
							{~tsd.running = 2;}
						);
					}
			});
		});
});

~categorizeChords = {
	if(~tsd.in[1] == 'M',
		{
			~currTonic = [
				~currChords[0],
				~currChords[2],
				~currChords[5]
			];
			~currSub = [
				~currChords[1],
				~currChords[3]
			];
			~currDom = [
				~currChords[4],
				~currChords[6]
			];
		},
		{if(~tsd.in[1] == 'm',
			{
				~currTonic = [
					~currChords[0],
					~currChords[2],
					~currChords[5]
				];
				~currSub = [
					~currChords[1],
					~currChords[3]
				];
				~currDom = [
					~currChords[4],
					~currChords[6]
				];
			},
			{"error".postln;}
		)}
		);
};
(// Test with a random value either C or G
~currChords = ~makeAllChords.(~keyboard.at('C'), 'M');
~categorizeChords.();
~tsd.state.postln;
~tsd.func;
~tsd.output.postln;
Pbind(*[
	note: Pseq(~tsd.output),
	dur: 1
]).play;
)



)