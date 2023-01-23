#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

// uniform float progress;
uniform sampler2D imageBase;
// uniform sampler2D displacement;
// uniform vec4 resolution;

float amount=.1;

uniform vec2 u_resolution;

float random2d(vec2 coord){
  return fract(sin(dot(coord.xy,vec2(12.9898,78.233)))*43758.5453);
}

void main(){
  
  vec2 coord=gl_FragCoord.xy/u_resolution;
  vec3 color=vec3(0.);
  
  vec4 image=texture2D(imageBase,coord);
  
  float noise=(random2d(coord)+.5)*amount;
  
  image.r+=noise + 5;
  image.g+=noise + 5;
  image.b+=noise + 5;
  
  gl_FragColor=image;
  
}