local function make()
	ShaderTimer = 0

 	return LG.newShader
	[[
	extern number red;
	extern number green;
	extern number blue;
	number rand(vec2 co)
	{
		return fract(sin(dot(co.xy, vec2(12.9898,78.233))) * 43758.5453);
	}

	vec4 effect(vec4 color,Image texture,vec2 texture_coords,vec2 screen_coords)
	{
		vec4 pixel = Texel(texture, texture_coords);

		if (pixel.g >= 1 && pixel.r >= 1 && pixel.b >= 1)
		{
			pixel.r = red;
			pixel.g = green;
			pixel.b = blue;
		}

		return pixel;
    }
 	]]

--[[
	[[
	//extern number screenWidth;
	extern number screenHeight;
	vec4 effect(vec4 color,Image texture,vec2 texture_coords,vec2 screen_coords)
	{
		vec2 neigh = texture_coords;
		neigh.x = neigh.x + 1;
		vec4 pixel = Texel(texture, texture_coords);
		vec4 pixel_n = Texel(texture, neigh);
		//number xx = floor(texture_coords.x * screenWidth * 4);
		number yy = floor(texture_coords.y * screenHeight * 4);
		number ym = mod(yy,3);


		if (mod(yy,2) == 0)
		{
			pixel.r = pixel.r - 0.5;
			pixel.g = pixel.g - 0.5;
			pixel.b = pixel.b - 0.5;
		}
		return pixel;
    }
 	]]
--]]

end

local function control(shader,colour)
	if ShaderTimer%3==0 then
		shader:send("red", colour[1]/255)
		shader:send("green", colour[2]/255)
		shader:send("blue", colour[3]/255)
	end
	ShaderTimer =  ShaderTimer + 1
end

return
{
	make = make,
	control = control,
}