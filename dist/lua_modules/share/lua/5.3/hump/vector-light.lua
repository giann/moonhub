local a,b,c,d=math.sqrt,math.cos,math.sin,math.atan2;local function e(f,g)return"("..tonumber(f)..","..tonumber(g)..")"end;local function h(i,f,g)return i*f,i*g end;local function j(i,f,g)return f/i,g/i end;local function k(l,m,n,o)return l+n,m+o end;local function p(l,m,n,o)return l-n,m-o end;local function q(l,m,n,o)return l*n,m*o end;local function r(l,m,n,o)return l*n+m*o end;local function s(l,m,n,o)return l*o-m*n end;local function t(l,m,n,o)return l==n and m==o end;local function u(l,m,n,o)return l<n or l==n and m<o end;local function v(l,m,n,o)return l<=n and m<=o end;local function w(f,g)return f*f+g*g end;local function x(f,g)return a(f*f+g*g)end;local function y(z,A)return b(z)*A,c(z)*A end;local function B(f,g)return d(g,f),x(f,g)end;local function C(l,m,n,o)return w(l-n,m-o)end;local function D(l,m,n,o)return x(l-n,m-o)end;local function E(f,g)local F=x(f,g)if F>0 then return f/F,g/F end;return f,g end;local function G(H,f,g)local I,i=b(H),c(H)return I*f-i*g,i*f+I*g end;local function J(f,g)return-g,f end;local function K(f,g,L,M)local i=(f*L+g*M)/(L*L+M*M)return i*L,i*M end;local function N(f,g,L,M)local i=2*(f*L+g*M)/(L*L+M*M)return i*L-f,i*M-g end;local function O(P,f,g)local i=P*P/w(f,g)i=i>1 and 1 or math.sqrt(i)return f*i,g*i end;local function Q(f,g,L,M)if L and M then return d(g,f)-d(M,L)end;return d(g,f)end;return{str=e,fromPolar=y,toPolar=B,mul=h,div=j,add=k,sub=p,permul=q,dot=r,det=s,cross=s,eq=t,lt=u,le=v,len2=w,len=x,dist2=C,dist=D,normalize=E,rotate=G,perpendicular=J,project=K,mirror=N,trim=O,angleTo=Q}