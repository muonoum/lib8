mx=setmetatable({},{
  __call=function(...)
    return mx.new(...)
  end
})

vmeta={
  __tostring=function(...)
    return mmeta.__tostring(...)
  end,
  __newindex=function(t,k,v)
    local x=
      k=="x" and 1 or k=="y" and 2 or
      k=="z" and 3 or k=="w" and 4 or nil

    t[1][x]=v
  end,
  __index=function(v,k)
    return
      k=="x" and v[1][1] or k=="y" and v[1][2] or
      k=="z" and v[1][3] or k=="w" and v[1][4] or
      nil
  end,
	__add=function(a,b)
		return mx{a.x+b.x,a.y+b.y,a.z+b.z}
	end,
		__sub=function(a,b)
		return mx{a.x-b.x,a.y-b.y,a.z-b.z}
	end,
	__div=function(a,b)
		return mx{a.x/b,a.y/b,a.z/b}
	end,
}

function mx.cross(a,b)
  return mx{
    a.y*b.z-a.z*b.y,
	  a.z*b.x-a.x*b.z,
	  a.x*b.y-a.y*b.x,
	}
end

function mx.mag(v)
	return sqrt(v.x*v.x+v.y*v.y+v.z*v.z)
end

function mx.norm(v)
  local mag=mx.mag(v)
  return mx{v.x/mag,v.y/mag,v.z/mag}
end

mmeta={
  __mul=function(a,b)
    if type(b)=="number" then
    	local out=mx(#a,#a[1])

    	for y=1,#a do
    		for x=1,#a[1] do
    		  out[y][x]=a[y][x]*b
    		end
      end

      return out
    end

    assert(#a[1]==#b)
    local out={}

  	for y=1,#a do
  	  out[y]={}

  		for x=1,#b[1] do
  		  local r=0
  			for n=1,#a[1] do
  			  r+=a[y][n]*b[n][x]
  			end

        out[y][x]=abs(r)<0.00005 and 0 or r
  		end
  	end

  	return setmetatable(out,
  	  getmetatable(a)
  	)
  end,
  __tostring=function(m)
    local out=""

    for y=1,#m do
      for x=1,#m[y] do
        out..=m[y][x].." "
      end

      if y~=#m then
        out..="\n"
      end
    end

    return out
  end
}

function mx:new(rs,cs,vs)
  if type(rs)=="table" then
    return setmetatable({rs},vmeta)
  end

  local m={}
  for y=1,rs do
    m[y]={}

    for x=1,cs do
      m[y][x]=vs and
        vs[(y-1)*rs+x] or
        rs==cs and x==y and
        1 or 0
    end
  end

  return setmetatable(m,mmeta)
end

function mx.transp(inp)
  local out=mx(#inp[1],#inp)

  for y=1,#inp do
    for x=1,#inp[y] do
      out[y][x]=inp[x][y]
    end
  end

  return setmetatable(out,mmeta)
end

function mx.sub(y1,x1,inp)
  local out={}

  for y2=1,#inp do
    if y2~=y1 then
      add(out,{})

      for x2=1,#inp[y2] do
        if x2~=x1 then
          add(out[#out],inp[y2][x2])
        end
      end
    end
  end

  return setmetatable(out,mmeta)
end

function mx.min(y,x,inp)
	return mx.det(mx.sub(y,x,inp))
end

function mx.minm(inp)
	local out=mx(#inp,#inp[1])

	for y=1,#inp do
		for x=1,#inp[1] do
			out[y][x]=mx.min(y,x,inp)
		end
	end

	return out
end

function mx.det(inp)
  assert(#inp==#inp[1])
  if(#inp==1) return inp[1][1]
	local r,s=0,1

	for x=1,#inp do
		r+=inp[1][x]*mx.min(1,x,inp)*s
		s=-1*s
	end

	return r
end

function mx.adj(inp)
  return mx.transp(mx.cofm(inp))
end

function mx.cof(y,x,inp)
	local m=mx.min(y,x,inp)
	return (-1)^(y+x)*m
end

function mx.cofm(inp)
	local out=mx(#inp,#inp[1])

	for y=1,#inp do
		for x=1,#inp[1] do
			out[y][x]=mx.cof(y,x,inp)
		end
	end

	return out
end

function mx.inv(inp)
	local det=1/mx.det(inp)
	local adj=mx.adj(inp)
	local out=mx(#inp,#inp[1])

	for y=1,#inp do
		for x=1,#inp[1] do
			out[y][x]=det*adj[y][x]
		end
	end

	return out
end

