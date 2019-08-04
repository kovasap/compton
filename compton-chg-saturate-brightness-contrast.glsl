uniform float opacity;
uniform bool invert_color;
uniform sampler2D tex;

/**
 * Adjusts the saturation of a color.
 *
 * From: https://github.com/AnalyticalGraphicsInc/cesium/blob/master/Source/Shaders/Builtin/Functions/saturation.glsl
 *
 * @param {vec3} rgb The color.
 * @param {float} adjustment The amount to adjust the saturation of the color.
 *
 * @returns {float} The color with the saturation adjusted.
 *
 * @example
 * vec3 greyScale = chg_saturation(color, 0.0);
 * vec3 doubleSaturation = chg_saturation(color, 2.0);
 */
vec3 chg_saturation(vec3 rgb, float adjustment) {
	// Algorithm from Chapter 16 of OpenGL Shading Language
	const vec3 W = vec3(0.2125, 0.7154, 0.0721);
	vec3 intensity = vec3(dot(rgb, W));
	return mix(intensity, rgb, adjustment);
}

/**
 * Adjusts the contrast of a color.
 *
 * @param adjustment the adjustment value, 0.0 - 1.0 reduces the contrast, &gt;
 *                   1.0 increases it
 */
vec3 chg_contrast(vec3 rgb, float adjustment) {
	return (rgb - 0.5) * adjustment + 0.5;
}

/**
 * Adjusts the brightness of a color.
 *
 * @param adjustment the adjustment value, 0.0 - 1.0 reduces the brightness,
 *                   &gt; 1.0 increases it
 */
vec3 chg_brightness(vec3 rgb, float adjustment) {
	return rgb * adjustment;
}

void main() {
	vec4 c = texture2D(tex, gl_TexCoord[0].st);
	// c = vec4(chg_saturation(vec3(c), 0.5), c.a);
	// c = vec4(chg_contrast(vec3(c), 0.5), c.a);
	c = vec4(chg_brightness(vec3(c), 0.2), c.a);
	if (invert_color)
		c = vec4(vec3(c.a, c.a, c.a) - vec3(c), c.a);
	c *= opacity;
	gl_FragColor = c;
}
