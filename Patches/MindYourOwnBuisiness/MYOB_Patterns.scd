// MYOB, v3.1, some example Tdefs for Bus control
// 14.07.2015

// CONTROL VIA TDEF
// Used with Event from a Tdef
(
(
Tdef(\resetParams, {
	1.do{
		(	'instrument': 'setBuses',
			'server': r.s,
			'value1': 0,
			'value2': 0,
			'value3': 0,
			'dur': 0.1,
			'where': \all
		).play;
	}});
);
(
Tdef(\setAllRand,{
	5.rand.do { |i|
		(	'instrument': 'setBuses',
			'server': r.s,		
			'value1': 1.0.rand,
			'value2': 1.0.rand,
			'value3': 1.0.rand,
			'dur': 0.1,
			'where': \all
		).play;
		0.5.wait;
	};
});
);

(
Tdef(\setAmps,{
	inf.do { |i|
		i = i%100 * 0.01;
		('instrument': 'setAmp','server': r.s,'value': i, 'where': \all).play;
		0.1.rand.wait;
	};
});
);

(
Tdef(\setParam1,{
	inf.do { |i|
		i = i%100 * 0.01;
		(	'instrument': 'setBus',
			'server': r.s,		
			'bus': 11,
			'value': i,
			'dur': 0.1,
			'where': \all
		).play;
		(0.1+0.1.rand).wait;
	};
});
);


(
Tdef(\setParam2,{
	inf.do { |i|
		i = i%100 * 0.01;
		(	'instrument': 'setBus',
			'server': r.s,
			'bus': 12,
			'value': 0.5-i%0.5,
			'dur': 0.1,
			'where': \all
		).play;
		0.5.rand.wait;
	};
});
);

(
Tdef(\setParam3,{
	inf.do { |i|
		i = i%100 * 0.01;
		(	'instrument': 'setBus',
			'server': r.s,
			'bus': 13,
			'value': 0.3.rand+i%0.5,
			'dur': 0.1,
			'where': \all
		).play;
		0.05.wait;
	};
});
);

(
Tdef(\setAllFX,{
	inf.do { |i|
		(	'instrument': 'setBusesFX',
			'server': r.s,
			'value1': 1.0.rand,
			'value2': 1.0.rand,
			'value3': 1.0.rand,
			'dur': 0.5,
			'where': \all
		).play;
		1.wait;
	};
});
);

(
Tdef(\sloRiseInSync,{
	inf.do { |i|
		i = i%100 * 0.01;
		(	'instrument': 'setBusesFX',
			'server': r.s,		
			'value1': i,
			'value2': i,
			'value3': i,
			'dur': 0.1,
			'where': \all
		).play;
		0.1.wait;
	};
});
);

// some Clock Control Tdefs
// slow down quick
Tdef(\clck_sldwn, {10.do {|i| r.send(\all, '/setclock', (~clock.tempo*60)-(i*3)); 0.5.wait;}});
// speed up
Tdef(\clck_speedup, {10.do {|i| r.send(\all, '/setclock', (~clock.tempo*60)+(i*3)); 0.5.wait;}});
// set spec bpms
Tdef(\clck_set60, {1.do{ r.send(\all, '/setclock', 60); 0.5.wait;}});
Tdef(\clck_set135, { 1.do{r.send(\all, '/setclock', 135); 0.5.wait;}});
Tdef(\clck_set112, { 1.do{r.send(\all, '/setclock', 112); 0.5.wait;}});
Tdef(\clck_set80, { 1.do{r.send(\all, '/setclock', 80); 0.5.wait;}});

Tdef(\clck_6Up, { r.send(\all, '/setclock', (~clock.tempo*60)+6); 0.5.wait;});
Tdef(\clck_6Dwn,{ r.send(\all, '/setclock', (~clock.tempo*60)-6); 0.5.wait;});



// SOME EXAMPLE PATTERNS


// if you need a gui:
// PdefAllGui(10);

(
Pdef(\busEnvVals,
	Pbind(
		\instrument, \envBusPerc,
		\server, r.s,
		\where, Pseq(r.nameList, inf), //
		\dur, Pwhite(0.1, 1),
		\legato, Pwhite(0.5,1.0),
	     \value, Ptuple([Pseq([0,1,0],inf), Pseq([1,0,0,1,0],inf), Pseq([0,1],inf), 1]).trace,
		\offset, 0.2,
		\bus, [11,12,13,14]
	)
);


Pdef(\init,
	Pbind(
		\instrument, \setBus,
		\server, r.s,
		\where, Pseq(r.nameList, 5), //
		\dur, 0.1,
		\legato, 2,
		\value, 0.7,
		\bus, [11, 12, 13, 14]
	).trace
);


Pdef(\bus,
	Pbind(
		\server, r.s,
		\instrument, \setBusles,
		\where, Pfunc({r.nameList.choose}), //
		\dur, 1,
		\value, Pwhite(0.2, 1),
		\bus, Pwhite(10, 20)
	)
);


Pdef(\noise,
	Pbind(
		\instrument, \busNoise,
		\server, r.s,
		\where, Prand(r.nameList, inf), //
		\dur, Pwhite(0.01, 1),
		\legato, 50,
		\freq, Prand([\rest, \rest, 440], inf),
		\bus, Pwhite(11,14)
	).trace
)
);

(
w = 3;
Pdef(\rhythm1,
	Pbind(
   		\instrument, \sd1,
   		\where,  r.nameList.choose, //specify target if you want   
   		\server, r.s,
   		\sustain, 0.1*Pwhite(0.01, 0.12) * w,
   		// choose some rhythm
//		\dur, Prand((Array.fill(w, { arg i; i/ w })).scramble.pyramid(1 + w.rand),inf)
		\dur, w/4 * Prand([1,1,0.5,0.125],inf) * Pseq([2,1,2,1,2,1,1,1,1]/6,inf)
));
);

(
w = 4;
Pdef(\rhythm2,
	Pbind(	
	    	\instrument, \sd2,
	    	\server, r.s,
	    // \sustain, w * Pseq([0.1, Pwhite(0.1,0.5,1)],inf),
	    \dur, 1 * Ppatlace([Pseq([2,3,2,2,3]/3,inf)-0.1,0.1],inf) //12/8ths pulse
));
);

(
Pdef(\rhythm3,
	Pbind(
   		\instrument, \sd3,
	    	\server, r.s,    		
	    	\i, Pn(Pseries(0.01,0.01,100),inf),
    		\sustain, Pkey(\i)*Pwhite(0.1,1.0),
//  		\dur, Prand((Array.fill(w, { arg i; i * w })).scramble.pyramid(1 +1.rand),inf)
		\dur, Pkey(\i)
));
);

(
Pdef(\rhythm4, 
	Pbind(
	\instrument, \sd4, 
	\where, 0,
	\server, r.s,
	\sustain, Pseq((0.1,0.15..1),inf),
	\dur, 2/3 * Pseq([0.25, 0.25, 0.5],inf)
	));
);

(
w = 5;
Pdef(\rhythm5, 
	Pbind(
		\instrument, \sd5, 
		\where, 0,
		\server, r.s,
		\sustain, Pseq((0.1,0.15..1),inf),
		\dur, Prand((Array.fill(5, { arg i; i/w })).scramble.pyramid(1 +10.rand),inf)
	));
);

/*
Here are some basic rumbapattern for dur param, try out
// clave son
	\dur,
		Ppatlace([Pseq([2,2,3,2,3]/3,inf)-0.1,0.1],inf) //12/8ths pulse
//		Ppatlace([Pseq([3,3,4,2,4]/4,inf)-0.1,0.1],inf)  //4/4s pulse
//clave rumba
	\dur,
		Ppatlace([Pseq([2,3,2,2,3]/3,inf)-0.1,0.1],inf) //12/8ths pulse
		// Ppatlace([Pseq([3,4,3,2,4]/4,inf)-0.05,0.05],inf) // 4/4s pulse
// clave bell patterns
	\dur,
		Ppatlace([Pseq([3,3,1,3,2,3,1]/3,inf)-0.1,0.1],inf) //12/8ths pulse
		// Ppatlace([Pseq([3,3,1,3,2,3,1]/4,inf),0],inf) // 4/4s pulse
// straight pulses
	\dur,
		1/3 // for 12/8ths
//		0.25 // for 4/4s
*/
(
Tdef(\freqstep, {
	100.do{ |i|
		i= i%100;
	(	'instrument': 'setBus',
			'server': r.s,		
			'bus': 11,
			'value': 0.3+0.1.rand,
			'dur': 0.1,
			'where': \all
		).play;
		1.wait;
	};
	});

);
);

