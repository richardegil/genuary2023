let bg     = '#111111';
let fg     = '#f1f1f1';
let pink   = '#FFC0CB';
let cyan   = '#00FFFF';
let grey   = '#5A5F79';
let purple = '#590F70';
let shadow;
let base;
let shapes;
let main;

let x;
let y;

let yoff = 0.0;



let imgClone;
let imgClone2;

// the frame rate
var fps = 60;

// the canvas capturer instance
var capturer = new CCapture({ format: 'png', framerate: fps });

const NUM_FRAMES = 360;
const T = 1;

function setup() {
  createCanvas(1000, 1000);
  
  // trying to get this graphics to be masked out by a shape in the 'base' graphic
  shadow = createGraphics(width, height);
  base = createGraphics(width, height);
  shapes = createGraphics(width, height);
  main = createGraphics(width, height);

  // this is optional, but lets us see how the animation will look in browser.
  frameRate(fps);

}
var startMillis; // needed to subtract initial millis before first draw to begin at t=0.

function draw() {

  if (frameCount === 1) {
    // start the recording on the first frame
    // this avoids the code freeze which occurs if capturer.start is called
    // in the setup, since v0.9 of p5.js
    capturer.start();
  }

  if (startMillis == null) {
    startMillis = millis();
  }

  // duration in milliseconds
  var duration = 6000;

  // compute how far we are through the animation as a value between 0 and 1.
  var elapsed = millis() - startMillis;
  var t = map(elapsed, 0, duration, 0, 1);

  // if we have passed t=1 then end the animation.
  if (t > 1) {
    noLoop();
    console.log('finished recording.');
    capturer.stop();
    capturer.save();
    return;
  }


  let _w = width;
  let _h = height;
  background(pink);
  // translate(width / 2 , height / 2);
  fill(fg);
  // shadow
  shadow.background(purple);
  for (let i = -width; i < width * 2; i += 10) {
    shadow.push();
    shadow.stroke(cyan);
    shadow.line(0 + i, 0, 0 + i +1000, height);
    shadow.pop();
  }

  // base layer
  base.push();
  base.translate(width / 2 , height / 2);
  base.clear();
  base.beginShape();
  let radius = 300;
  let xoff = 0;

  for (var a = 0; a < TWO_PI; a += 0.2) {
    let offset = map(noise(xoff, yoff), 0, 1, -25, 25);
    let r = radius + offset;
    let x = r * cos(a);
    let y = r * sin(a);
    base.vertex(x, y);
    xoff += 0.1;
  }
  base.endShape();
  yoff += 0.01;
  base.pop();

  base.push();
  base.translate(width / 2 + 300 , height / 2 + 300);
  // base.clear();
  base.beginShape();
  radius = 100;
  xoff = 0;

  for (var a = 0; a < TWO_PI; a += 0.2) {
    let offset = map(noise(xoff, yoff), 0, 1, -25, 25);
    let r = radius + offset;
    let x = r * cos(a);
    let y = r * sin(a);
    base.vertex(x, y);
    xoff += 0.1;
  }
  base.endShape();
  yoff += 0.01;
  base.pop();

  base.push();
  base.translate(0 , 0);
  // base.clear();
  base.beginShape();
  radius = 200;
  xoff = 0;

  for (var a = 0; a < TWO_PI; a += 0.2) {
    let offset = map(noise(xoff, yoff), 0, 1, -25, 25);
    let r = radius + offset;
    let x = r * cos(a);
    let y = r * sin(a);
    base.vertex(x, y);
    xoff += 0.1;
  }
  base.endShape();
  yoff += 0.01;
  base.pop();

  // top layer
  main.push();
  main.translate(width / 2 , height / 2);
  main.clear();
  main.noStroke();
  main.beginShape();
  radius = 300;
  xoff = 0;

  for (var a = 0; a < TWO_PI; a += 0.2) {
    let offset = map(noise(xoff, yoff), 0, 1, -25, 25);
    let r = radius + offset;
    let x = r * cos(a);
    let y = r * sin(a);
    main.vertex(x - 120, y - 140);
    xoff += 0.1;
  }
  main.endShape();
  yoff += 0.01;
  main.pop();

  main.push();
  main.translate(width / 2 + 300 , height / 2 + 300);
  // main.clear();
  main.noStroke();
  main.beginShape();
  radius = 100;
  xoff = 0;

  for (var a = 0; a < TWO_PI; a += 0.2) {
    let offset = map(noise(xoff, yoff), 0, 1, -25, 25);
    let r = radius + offset;
    let x = r * cos(a);
    let y = r * sin(a);
    main.vertex(x - 60, y - 80);
    xoff += 0.1;
  }
  main.endShape();
  yoff += 0.01;
  main.pop();

  main.push();
  main.translate(0 , 0);
  // main.clear();
  main.noStroke();
  main.beginShape();
  radius = 200;
  xoff = 0;

  for (var a = 0; a < TWO_PI; a += 0.2) {
    let offset = map(noise(xoff, yoff), 0, 1, -25, 25);
    let r = radius + offset;
    let x = r * cos(a);
    let y = r * sin(a);
    main.vertex(x - 60, y - 80);
    xoff += 0.1;
  }
  main.endShape();
  yoff += 0.01;
  main.pop();


  // image(shadow,-width / 2 , -height / 2);

  ( imgClone = shadow.get() ).mask( base.get() );
  // image(imgClone,-width / 2 , -height / 2);
  // image(main, -width / 2 , -height / 2);
  image(imgClone,0, 0);
  image(main, 0, 0);

  // handle saving the frame
  console.log('capturing frame');
  capturer.capture(document.getElementById('defaultCanvas0'));
}


// function buttonPress() {
//   if (capture == false) {
//       capture = true;
//       document.getElementById("myButton").value='Saving Frames... Press Again to Cancel'; 
//       frameCount = 0;
//   } else {
//       location.reload(); //refresh the page (starts animation over, stops saving frames)
//   }
// }