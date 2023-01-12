let R = (a=1)=>Math.random()*a;
let L = (x,y)=>(x*x+y*y)**0.5; // Elements by Euclid 300 BC

 

function setup() {
  createCanvas(1000, 1000);
  background('#432');
}

function draw_circle([x,y],r,c) {
  noStroke(); fill(c);
  circle((x+1)*width/2, (y+1)*width/2, r*2);
  // rect((x+1)*width/2, (y+1)*width/2, r/2, r/2)
  // line((x+1)*width/2, (y+1)*width/2, (x+1)*width, (y+1)*width,)
}

function sdf_circle([x,y], [cx,cy], r) {
  x -= cx;
  y -= cy;
  return L(x, y) - r;
}

function sdf_box([x,y], [cx,cy], [w,h]) {
  x -= cx;
  y -= cy;
  return k(abs(x)-w, abs(y)-h);  
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

  // let bal = sdf_circle([x,y], [.3,.3], .4);
  // let lin = abs(y)-.3;
  // let lin2 = abs(x)-.3;
  // bal = abs(bal) - .1;
  // bal = abs(bal) - .05;
  // x = abs(x) - .5;
  let bal = abs(sdf_rep(sdf_circle([x / wave,y *  wave], [-.2,0], .1),.4))-.05;
  let bbl = abs(sdf_rep(sdf_circle([x / wave,y *  wave], [.2,0], .1),.4))-.05;
  return max(bal, bbl);
}

// if (k(abs(x)-.8, abs(y)-.8) < 0) {
//   // draw stuff
  
// }

function draw() {

 	let wave = map(tan(radians(frameCount)), -1, 1, -0.0005, 0.75);
  	let wave2 = map(cos(radians(frameCount)) + sin(radians(frameCount)), -1, 1, 0.75, -0.0005);
  	let n = noise( 0.01 + frameCount * 0.001);



  for (let k = 0; k < 10000; k++) {
    let p = [R(2)-1, R(2)-1];
    let d = sdf(p);
    let col = '#000';
    if (d < -.01) col = '#00FFFF';
    if (d > .01) col = '#590F70';
    draw_circle(p, 2, col);    
  }
}