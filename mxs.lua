function scale(x,y,z)
	return mx(4,4,{
		x,0,0,0,
		0,y,0,0,
		0,0,z,0,
		0,0,0,1,
	})
end

function scalev(v)
  return scale(v.x,v.y,v.z)
end

function trans(x,y,z)
	return mx(4,4,{
		1,0,0,0,
		0,1,0,0,
		0,0,1,0,
		x,y,z,1,
	})
end

function transv(v)
  return trans(v.x,v.y,v.z)
end

function rotv(v)
  return rot(v.x,v.y,v.z)
end

function rot(x,y,z)
  return rotz(z)*roty(y)*rotx(x)
end

function rotx(a)
	local s,c=sin(a),cos(a)

	return mx(4,4,{
		1, 0,0,0,
		0, c,s,0,
		0,-s,c,0,
		0, 0,0,1,
	})
end

function roty(a)
	local s,c=sin(a),cos(a)

	return mx(4,4,{
		c,0,-s,0,
		0,1, 0,0,
		s,0, c,0,
		0,0, 0,1,
	})
end

function rotz(a)
	local s,c=sin(a),cos(a)

	return mx(4,4,{
		 c,s,0,0,
		-s,c,0,0,
		 0,0,1,0,
		 0,0,0,1,
	})
end

function persp(f)
  return mx(4,4,{
		1,0,0,  0,
		0,1,0,  0,
		0,0,1,1/f,
		0,0,0,  1,
	})
end

function look(from,to,up)
  local forward=mx.norm(from-to)
  local right=mx.norm(mx.cross(up,forward))
  local up=mx.cross(forward,right)
	
	return mx(4,4,{
		  right.x,  right.y,  right.z,0,
		     up.x,     up.y,     up.z,0,
		forward.x,forward.y,forward.z,0,
		   from.x,   from.y,   from.z,1,
		})
end
