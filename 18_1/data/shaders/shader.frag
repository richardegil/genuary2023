#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;
uniform sampler2D image;
uniform sampler2D displacement;
float amount=0.3;

float random2d(vec2 coord){
  return fract(sin(dot(coord.xy,vec2(12.9898,78.233)))*43758.5453);
}

void main(){
  // multiplying by 6.0 zooms out of the canvas
  vec2 coord = 4.0 * gl_FragCoord.xy / u_resolution;
  for(int n = 1; n < 100; n++){
    float i = float(n);
    coord+=vec2(.3/ i * cos(i *coord.y+u_time+.5 * i)+.8,.4/i *cos(coord.x+u_time+.5 * i)+1.6);  
  }

  // coord += vec2(0.7 / sin(coord.y + u_time + 0.3) + 0.8, 0.4 / sin(coord.x + u_time + 0.3) + 1.6);

  float noise=(random2d(coord)-.5)*amount;

  vec3 color = vec3(0.1 * cos(coord.x) + 0.1, 0.1*cos(coord.y) + 0.0, cos(coord.x + coord.y));

  color.r+=noise / 2.;
  color.g+=noise / 2.;
  color.b+=noise / 2.;

  float gray=dot(color.rgb,vec3(0.1529, 0.0275, 0.3255));
// gl_FragColor=vec4(grayscale,color.a);

  gl_FragColor = vec4(color + gray, 1.0);
}