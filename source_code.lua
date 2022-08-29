--bezier curve time
function lerp(s,e,m)
	return s*(1-m)+e*m
end

function lerp2d(p1,p2,t) --lerp
	x=lerp(p1.x,p2.x,t)    --two 2d
	y=lerp(p1.y,p2.y,t)    --points
	return x,y
end

poke(0x5f2d,1)--devkit mouse
p1={x=32,y=96}--2d points
p2={x=32,y=32}
p3={x=96,y=32}
p4={x=96,y=96}
ps={p1,p2,p3,p4}--points
npt=4 --number of desired points
ind=1 --index used for selected point
t=.5  --time value used across lerps

--[[function drawlerps(p)--lerp the points
	if(lp~=nil and p~=p1)lx,ly=lerp2d(lp,p,t)line(lx,ly,llx,lly,11)
	circ(lx,ly,2,11)
	lp=p
	if(p~=p4 and p~=p4)llx=lx lly=ly
end]]

--[[function drawp(p)--visualize points
	circ(p.x,p.y,3,7)
	if(lp~=nil and p~=p1)line(lp.x,lp.y,p.x,p.y,7)
	lp=p --update most recent point
end]]

function drawp(g,lps)
if(not lps)lps={}--lerped points
if(not g)g=0     --generation
	for i=1,#ps-g,1 do
		if g==0 then
			circ(ps[i].x,ps[i].y,3,7)
			if ps[i+1] then
				line(ps[i].x,ps[i].y,ps[i+1].x,ps[i+1].y,7)
				lp={}
				lp.x,lp.y=lerp2d(ps[i],ps[i+1],t)
				add(lps,lp,i)
			end
		else
			if lps[i+1] then
				lp={}--lerped p
				lp.x,lp.y=lerp2d(lps[i],lps[i+1],t)
			 circ(lps[i].x,lps[i].y,2,g)
				line(lps[i].x,lps[i].y,lps[i+1].x,lps[i+1].y,g)
				add(lps,lp)
			end
		end
	end
	if(g<#ps-1)drawp(g+1,lps)
end
lp={}
lps={}
nlp={}

function drawp(g)
	if(not g)g=0
	if g==0 then
		for i=1,#ps,1 do
			circ(ps[i].x,ps[i].y,3,7)
			if(ind==i)m="\^ip" else m="p"
			?m..i,ps[i].x+5,ps[i].y+5
			if ps[i+1] then
				line(ps[i].x,ps[i].y,ps[i+1].x,ps[i+1].y,7)
				lp.x,lp.y=lerp2d(ps[i],ps[i+1],t)
			end
			add(lps,lp,i)
			drawp(g+1)
		end
	else
		for i=1,#lps,1 do
			circ(lp.x,lp.y,2,g+1)
			if(llp)line(lp.x,lp.y,llp.x,llp.y,g+1)
			if(lp~=lps[#lps])llp=lp
			--nlp.x,nlp.y=lerp2d(llp,lp,t)
		end
		--if(#ps-g~=1)drawp(g+1)
	end
end

function _update60()
	mx=stat(32)my=stat(33)
	if(btnp(🅾️)and ind>1)ind-=1--change selected
	if(btnp(❎)and ind<#ps)ind+=1--point
	if(btnp(⬅️)and t>.05)t-=.05
	if(btnp(➡️)and t<.95)t+=.05
	if stat(34)~=0 and ps[ind] then
		sp=ps[ind] --selected point
		sp.x=mx --move point
		sp.y=my
	end
	--t=time()%1
end

function _draw()
	cls()
	drawp()
	--foreach(ptt,drawlerps)
	spr(0,mx-1,my-1)
end
