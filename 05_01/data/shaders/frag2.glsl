#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform float progress;
uniform sampler2D image;
uniform sampler2D displacement;
uniform vec4 resolution;

uniform vec2 u_resolution;

void main(){
  
  vec2 st=gl_FragCoord.xy/u_resolution;
  vec4 displace=texture2D(displacement,st.xy);
  
  vec2 displacedUV=vec2(
    st.x,
    st.y
  );
  
  displacedUV.x=mix(st.x,displace.r,progress);
  
  vec4 color=texture2D(image,displacedUV);
  // color.r=texture2D(image,displacedUV+vec2(.005,0.)*progress).r;
  // color.g=texture2D(image,displacedUV+vec2(.01,0.)*progress).g;
  // color.b=texture2D(image,displacedUV+vec2(.02,0.)*progress).b;
  
  color.r=texture2D(image,displacedUV+vec2(.005,0.)*progress).r;
  color.g=texture2D(image,displacedUV+vec2(.00015,0.)*progress).g;
  color.b=texture2D(image,displacedUV+vec2(.0001,0.)*progress).b;
  
  gl_FragColor=color;
  
}