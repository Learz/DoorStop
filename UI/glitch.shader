shader_type canvas_item;

const float shake_power = 0.03;
const float shake_rate = 0.2;
const float shake_speed = 5.0;
const float shake_block_size = 30.5;
const float shake_color_rate = 0.01;

float random( float seed )
{
	return fract( 543.2543 * sin( dot( vec2( seed, seed ), vec2( 3525.46, -54.3415 ) ) ) );
}

void fragment( )
{
	vec2 fixed_uv = SCREEN_UV;
	fixed_uv.x += (random((trunc(SCREEN_UV.y * shake_block_size) / shake_block_size) + TIME) - 0.5) * shake_power;

	vec4 pixel_color = texture( SCREEN_TEXTURE, fixed_uv );
	pixel_color.r = mix(
		pixel_color.r
	,	texture( SCREEN_TEXTURE, fixed_uv + vec2( shake_color_rate, 0.0 ) ).r
	, 1
	);
	pixel_color.b = mix(
		pixel_color.b
	,	texture( SCREEN_TEXTURE, fixed_uv + vec2( -shake_color_rate, 0.0 ) ).b
	, 1
	);
	COLOR = pixel_color;
//	COLOR = vec4(0,0,0,1);
}
