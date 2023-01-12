let master;
let bubbles = [];
let numberOfBubbles = 5;

let ready = false; 

let osc;  
let osc2; 
let waveform; 

let gui; 

let notes = 
[
  { note: "D4",  duration: "8n", timing: 0.5 },
  { note: "F4", duration: "8n", timing: 0.4 },
  { note: "A2", duration: "8n", timing: 0.4 },
  { note: "C5", duration: "8n", timing: 0.4 },
  { note: "C2", duration: "8n", timing: 0.4 },
];

function initializeAudio() { 
  waveform = new Tone.Waveform();
  Tone.Master.connect(waveform); 
  Tone.debug = true;
  Tone.Master.volume.value = -9; // -9 decibels  
}


// function initializeAudio() {
  
//   osc = new Tone.Oscillator();
//   osc.type = "sine"; // triangle, square or sawtooth
//   osc.frequency.value = 220;  // hz
//   osc.start();
//   osc.toDestination();  // connect the oscillator to the audio output
  
//   osc2 = new Tone.Oscillator();
//   osc2.type = "sine"; // triangle, square or sawtooth
//   osc2.frequency.value = 220;  // hz
//   osc2.start();
//   osc2.toDestination();  // connect the oscillator to the audio output
  
//   let lfo = new Tone.LFO(0.1, 200, 240);
//   lfo.connect(osc2.frequency);
//   lfo.start();
  
//   waveform = new Tone.Waveform();
//   Tone.Master.connect(waveform);
//   Tone.Master.volume.value = -9; // -9 decibels  
  
//   let oscType = ["sine", "triangle", "square", "sawtooth"];
  
//   gui = new dat.GUI();
//   gui.add(osc.frequency, "value", 110, 330).step(0.1).name("frequency");
//   gui.add(osc, "type", oscType).name("osc1 type");
//   gui.add(osc2, "type", oscType).name("osc2 type");
// }

function setup() {
  let cnv = createCanvas(1000, 1000);
  const seed = 1212775 * Date.now();
  
  console.log(seed);
  // randomSeed(13909089463786197008)
  // randomSeed(13909105994996791000);
  // randomSeed(seed);
  randomSeed(2029465445827376000);
  // 13909105994996791000
  master = new Bubble(width / 2, height / 2, true);
  translate( width / 2, height / 2);
  for (let i = 0; i < numberOfBubbles; i++) {
    bubbles[i] = new Bubble((width / numberOfBubbles * i) + 48 * 2, height / 2, false);
  }
}

function draw() {
  if (ready) {
    // our main sketch
    background('#111111');
    stroke('white');
    fill('white');

    background(17);
    master.update();
    master.display();
    

    // wave
    let buffer = waveform.getValue(0); // grab the left channel 
    translate( 0, 0);
    let start = 0; 
    for (let i=1; i < buffer.length; i++) {
      if (buffer[i-1] < 0 && buffer[i] >= 0) {
        start = i;
        break; // interrupts the for loop 
      }
    }
    let end = buffer.length/2 + start; 
    
    noStroke();
    fill(188, 143, 143);
    beginShape();
    for (let i=start; i < end; i++) {      
      let x = map(i, start, end, 0 - 100, width + 600);
      let y = map(buffer[i], -1, 1, 0, height);      
      vertex(x, y);
    }
    vertex(width, height); // bottom right
    vertex(0, height); // bottom left
    endShape(CLOSE);


    // bubbles
    for (let i = 0; i < bubbles.length; i++) {
      bubbles[i].update();
      bubbles[i].display();
             

      for (let j = 0; j < bubbles.length; j++) {
        let test = false;
        if (!test && master.intersects(bubbles[j])) {
          test = true;
          let limiter = new Tone.Limiter(-2);
          const synth = new Tone.Synth(
            {
              oscillator: {
                type: "sine"
              },
              debug: true,
              envelope: {
                attack: 0.01,
                decay: 0.1,
                sustain: 0.1,
                release: 0.5
              }
            }
          ).chain(limiter, Tone.Master).toDestination();
          synth.volume.value = -15;
          
          console.log('test', test);
          master.changeColor();
          bubbles[j].changeColor();
          let tone = notes[int(random(notes.length))];
          // playTone(tone);
          synth.triggerAttackRelease(tone.note, tone.duration);

        } else {
          test = false;
        }
      }
    }
  }
  else {
    background('black'); 
    fill('white');
    textAlign(CENTER, CENTER);
    text("CLICK TO START!", width/2, height/2);
  }  
}

function playTone(tone) {

  let limiter = new Tone.Limiter(-2);
  const synth = new Tone.Synth(
    {
      oscillator: {
        type: "sine"
      },
      debug: true,
      envelope: {
        attack: 0.01,
        decay: 0.1,
        sustain: 0.1,
        release: 0.5
      }
    }
  ).chain(limiter, Tone.Master).toDestination();
  synth.volume.value = -15;
  synth.triggerAttackRelease(tone.note, tone.duration);
}

//----------------------------------------------------
function mousePressed() {
  if (ready == false) {
    ready = true;
    initializeAudio();
  }  
}