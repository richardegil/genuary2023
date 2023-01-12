// Jeff (twitter @ippsketch)
// template for saving png files from p5.js sketch using CCapture

let R = (a=1)=>Math.random()*a;
let L = (x,y)=>(x*x+y*y)**0.5; // Elements by Euclid 300 BC

var capture = false; // default is to not capture frames, can be changed with button in browser
var capturer = new CCapture({format:'jpg'});

const NUM_FRAMES = 360;
const T = 1;

function draw_circle([x,y],r,c) {
    noStroke(); fill(c);
    circle((x+1)*width/2, (y+1)*width/2, r*2);
}

function sdf_circle([x,y], [cx,cy], r) {
    x -= cx;
    y -= cy;
    return L(x, y) - r;
}

let k = (a,b)=>a>0&&b>0?L(a,b):a>b?a:b;

function sdf_rep(x, r) {
    x/=r;
    x -= Math.floor(x)+.5;
    x*=r;
    return x;
}

function sdf([x,y]) {
    let wave = map(tan(radians(frameCount)), -1, 1, -0.5, 0.95);
    let wave2 = map(cos(radians(frameCount)) + sin(radians(frameCount)), -1, 1, 0.25, -0.0005);
    let n = noise( 0.01 + frameCount * 0.001);
    let bal = abs(sdf_rep(sdf_circle([x / wave,y *  wave], [-.2,0], .1),.4))-.05;
    let bbl = abs(sdf_rep(sdf_circle([x / wave,y *  wave], [.2,0], .1),.4))-.05;
    return max(bal, bbl);
}

function setup() {
    createCanvas(1000, 1000);
    background('#111111');
}

function sdf_box([x,y], [cx,cy], [w,h]) {
    x -= cx;
    y -= cy;
    return k(abs(x)-w, abs(y)-h);  
}

function draw() {
    if (capture && frameCount==1) capturer.start(); // start the animation capture

    for (let k = 0; k < 10000; k++) {
        let p = [R(2)-1, R(2)-1];
        let d = sdf(p);
        let col = '#000';
        if (d < -.01) col = '#00FFFF';
        if (d > .01) col = '#590F70';
        draw_circle(p, 2, col);    
    }

    if (capture){
        capturer.capture( canvas ); // if capture is 'true', save the frame
        if (frameCount-1 == NUM_FRAMES){ //stop and save after NUM_FRAMES
            capturer.stop(); 
            capturer.save(); 
            noLoop(); 
        }
    }
}

function buttonPress() {
    if (capture == false) {
        capture = true;
        document.getElementById("myButton").value='Saving Frames... Press Again to Cancel'; 
        frameCount = 0;
    } else {
        location.reload(); //refresh the page (starts animation over, stops saving frames)
    }
}