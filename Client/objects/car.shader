shader_type canvas_item;

uniform bool hasSpeedPowerup;

const float PI = 3.14159265358979323846;
const float freq = 5.0;

void fragment() {
	vec4 samp = texture(TEXTURE, UV);
	if (hasSpeedPowerup) {
		float r = sin(freq*TIME);
		float g = sin(freq*TIME + 2.0*PI/3.0);
		float b = sin(freq*TIME + 4.0*PI/3.0);
		COLOR.rgb = mix(samp.rgb, vec3(r,g,b), 0.5);
		COLOR.w = samp.w
	}
	else {
		COLOR = samp;
	}
}