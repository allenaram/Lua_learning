--Allen��luaѧϰ�ʼ�

--ʹ��SciTE�༭�������������룬����������գ�http://blog.csdn.net/yao_yu_126/article/details/8661988



---------------------------------------��������----------------------------------------------

-- һЩ����������ѧϰ���������ļ����ú����������������հ���

---------------------------------------------------------------------------------------------



---------��������----------
--[[
function fact(n)
	if n==0 then
		return 1
	else
		return n*fact(n-1)
	end
end

print("Input a number please!")
a=io.read("*num")
print(fact(a))
--]]
---------------------------



-----dofile�������������ļ��еĺ���-----
--[[
dofile("math1.lua")

print("Please input two numbers\n")
a=io.read("*number")
b=io.read("*number")

n=sum_of_squares(a,b)

print(a.."^2 +"..b.."^2 ="..n)
--]]
----------------------------------------



-------�������ݸ�����-------
--[[
fun1=function(n1,n2)
	sum=n1+n2
	print(sum)
end

fun1(1,2)
--]]
----------------------------



-----����������Ϊ������������-----
--[[
function anonymous(tab, fun)
    for k, v in pairs(tab) do
        print(fun(k, v))
    end
end
tab = { key1 = "val1", key2 = "val2" }
anonymous(tab,
function(key, val)
    return key .. " = " .. val
end
)
--]]
----------------------------------



--------����������Ŀ����--------
--[[
function average(...) 					-- ...��ʾ������������
   result = 0
   local arg={...}
   for i,v in ipairs(arg) do
      result = result + v
   end
   print("�ܹ����� " .. #arg.. " ����")	-- #table���ز�������
   return result/#arg
end

print("ƽ��ֵΪ",average(10,5,3,4,5,6))
--]]
--------------------------------



----------�հ�����----------
--[[
    function test()
        local i=0
        return function()
            i=i+1
            return i
        end
    end
    c1=test()
    c2=test()			-- c1,c2�ǽ�����ͬһ��������ͬһ���ֲ������Ĳ�ͬʵ�������������ͬ�ıհ�
						-- �հ��е�upvalue���Զ���������һ��test()�ͻ����һ���µıհ�
    print(c1()) 		-->1
    print(c1()) 		-->2    �ظ�����ʱÿһ�����ö����ס��һ�ε��ú��ֵ������˵i=1���Ѿ�
    print(c2())   	   	-->1    �հ���ͬ����upvalue��ͬ
    print(c2())			-->2
--]]
-----------------------------



--------�ַ�������---------
--[[
start,end1=string.find("Hello Lua user", "Lua",7)	-- �����������ǿ�ʼ������λ��
print(start,end1)
--]]
---------------------------



--------����ʽ���---------
--[[
f=3
print(string.format("%05.3d",f))	-- %05.3d��05��ʾռλ5��������ಹ�㣬.3��ʾС�������3λ
--]]
---------------------------







-----------------------------------------------������--------------------------------------------------

-- ���ڵ����������ݣ����ϵĽ̳��ձ�û��������ܶ���������һ�������Ƿ���
-- ���²��Ľ�����ԱȽϺã�http://www.cnblogs.com/Richard-Core/p/4343635.html
-- �б��ڴ˻�������ȷ�����˵�����£�
-- 1.����������ʵ�ֵ������﷨���ɷ�Ϊ����for��������while�������ȣ�����for�õıȽ϶�
-- 2.���������������Ƿ񱣴�״̬���ɷ�Ϊ��״̬����������״̬������
-- 3.��״̬������ÿ�ε�������Ҫ�ֶ�������Ʊ���������Ŀ��Ʊ����������ε����������������������
-- 4.��״̬������������״̬��ÿ�ε���ʱ�ɵ�ǰ״̬��������������������Ҫ���Ʊ�����״̬���������
-- 5.��״̬�����������ñհ�ʵ�֣�upvalue����״̬����Ҳ���԰�״̬��Ϣ����״̬�����һ������
--	 ÿ�ε����޸�״̬������ʵ��״̬�л�
-- 6.����for������ʵ��ʱ������ѡ����״̬��������������С

-------------------------------------------------------------------------------------------------------



---------Ĭ�ϵ�����---------
--[[
tab1={key1="val1",key2="val2","val3"}
for k,v in pairs(tab1) do  -- pairs(table)�г�table�е�����Ԫ�أ�������������Ż�������
	print(k..':'..v)
end

print('-------�ָ���-------')

tab1.key1=nil              -- �ͷ�����key1
for k,v in pairs(tab1) do
	print(k..':'..v)
end
--]]
----------------------------



--------����for������-------
--[[
-- 1.����for������Ҫ��������������������״̬���������Ʊ���������ʱ����״̬�����Ϳ��Ʊ������������������
-- 2.����״̬�������У�״̬������״̬�޹أ�����ֻ��һ��Ҫ�õ��ĳ�������Ҫ�����ı����Ƶ��������ĳ�����
-- 3.�ڶ�״̬�������У�״̬�����п����ڱ���״̬��Ϣ�����ڵ���������ʵʱ�޸ģ���ȻҲ�����ñհ���
-- 4.״̬����������ָ��ҵ��������˺ܴ����ţ�������������������Ϊ�С�״̬�������ƺ��������ʣ�������
--	 ��һ����¼״̬������������ǳ�����
-- 5.����for�����ڷ��صĵ�һ������Ϊnilʱֹͣ������

function square(iteratorMaxCount,currentNumber)
   if currentNumber<iteratorMaxCount
   then
      currentNumber = currentNumber+1
   return currentNumber, currentNumber*currentNumber
   end
end

for i,n in square,3,0
do
   print(i,n)
end
--]]
-----------------------------



---------��״̬������--------
--[[
-- ��ʵ�ϣ�����Ҳ����״̬������
function iter (a, i)
    i = i + 1
    local v = a[i]
    if v then
       return i, v
    end
end

function ips (a)
    return iter,a,0  	-- ���ص�������iter��״̬����a�����Ʊ�����ʼֵ1
end

a={"hello","lua","!"}
for i,v in ips(a) do 	-- for��ִ��ips����ȡ��������iter����a�����Ʊ�������ʼΪ0������ʱ��䣩
	print(i,v)
end
--]]
-----------------------------



-----�հ�ʵ�ֶ�״̬������-----
--[[
function iterator(a)	-- ��������
	local index=0    	-- ״̬
	local count=#a    	--   	       \  �հ�
	return function()	-- �հ�����    /
				if index==0 then
					index=1
				elseif index==1 then
					index=3
				elseif index==3 then
					index=2
				elseif index==2 then
					index=4
				else
					index=nil 	-- a[nil]��ֵΪ�գ�����ʱ����ֹͣ
				end
				return a[index]
			end
end

table={'how','you','are','baby'}
for out in iterator(table) do		-- ����ֻ���ص�����������״̬�ıհ�����״̬�����Ϳ��Ʊ�����nil
	print(out)
end
-- ��Ȼ�����������������״̬������ʵ��
--]]
-------------------------------








--------------------------------------table---------------------------------------

-- tableǰ���Ѿ����õ��ˣ������һ��ѧϰ��һЩ���õ�table��������
-- ���⣬��˳������������tableҲ�ɳ�Ϊ����

----------------------------------------------------------------------------------



----------������table.concat()----------
--[[
fruit={'apple','banana','orange'}
print('����fruit��',table.concat(fruit))
print('����fruit����ָ�����Ÿ�����',table.concat(fruit,'��ToT��'))
print('ָ���������ӵ�Ԫ�أ�',table.concat(fruit,',',2,3))    	-- �ƺ��ڶ�����������ʡ��
--]]
----------------------------------------



-----------������table.sort()-----------
--[[
table1={19,21,32,45,76}
table.sort(table1,function(n1,n2)  	--���ʽ����1ʱ����������0ʱ����
					return n1>n2
				  end)

for i,v in pairs(table1) do
	print(i,v)
end
--]]
----------------------------------------







-----------------------------------ģ�����-----------------------------------------

-- 1.����û����ȷ�綨'ģ��'�롮�������ƺ�luaд�Ľ�ģ�飬Cд�Ľа������Ҳ������ְ�
-- 2.����ģ����ص�������ַ���⣬Ҳ��������򵥵ذ���չģ�����������һ��Ŀ¼��
-- 3.require��dofile���ط�ʽ������
--	 1) dofileÿ�ε���Ҫ���¼��ء�����ģ�飻requireֻ��Ҫ����һ�Σ��ظ�����ʱ����Ѽ���ģ�����ȡ��
--	 2)	require�ǽ�һ������װ����loadfile������C����loadlib����loadfile��loadlib��������ģ�飬��
--      �����У�������ģ���ļ�����һ���������أ���Ҫ���иú������ܵ���ģ�����ݣ���require���Ǽ���
--      �����д��룬ֱ�ӿ��Ե���ģ������
--	 3) requireֻ��Ҫ�ļ�����dofile��Ҫ�ļ�·��
-- 4.�ۺ���˵��������require����

--�ο���http://blog.csdn.net/leecrest/article/details/31742419
--	    http://blog.csdn.net/u012861978/article/details/54667179

------------------------------------------------------------------------------------



--------��require�����ļ�--------
--[[
a1=require('test_require')   -- һ��Ҫ�󱻼���ģ��Ѻ���������һ�����ˣ������������������Ҳ�У����سɹ�Ĭ�Ϸ���true��ֱ�ӿ���ʹ��ģ����ĺ���
print(type(a1))
print(a1.Fac(5))
print(a1.square(5))
--]]
--------------------------------








--------------------------------------Ԫ��metatable---------------------------------------

-- 1.����Ԫ��metatable��Ԫ����metamethod�ĸ����Ҿ����˺ܾò����ף��̳������Ԫ���������ã��á���
--   ������Ϊ�������������������ֳ�ѧ��̫�����ˡ�����˵����Ҫ�����ࣺܶ���û��__indexԪ������
--   ��ô����һ�����в����ڵļ�ʱ���᷵��nil�������__indexԪ��������ʱ�ͻ�ȥԪ�����ı��������ü���
--   ��ν���ı�����Ϊ����
-- 2.Ԫ����������һ����Ҳ������һ������

------------------------------------------------------------------------------------------



---------__indexԪ����---------
--[[
mytable=setmetatable({key1="value1"},{__index=
function(mytable,key)
	if key=="key2" then
		return "metatablevalue"
	else
		return nil
	end
end
})
print(mytable.key1)
print(mytable.key2			)		-- ���õļ�table���Ҳ�������ȥmetatable�е�__index������
									-- __index�Ǻ������Ͱ�table�͵��õļ���Ϊ��������ȥִ�иú���
print(mytable.key3)
--]]
-------------------------------



---------__newindexԪ����--------
--[[
mymetatable={}
mytable=setmetatable({key1="value"},{__newindex=mymetatable})
print(mytable.key1)

mytable.newkey="��ֵ2"
print(mytable.newkey,mymetatable.newkey)

mytable.key1="��ֵ1"
print(mytable.key1,mymetatable.key1)
--]]
---------------------------------



------__newindexԪ����Ϊ����------
--[[
mytable = setmetatable({key1 = "value1"}, {
  __newindex = function(mytable, key, value)
		rawset(mytable, key, "\""..value.."\"")   -- rawset(����)��������__newindexԪ�������и�ֵ

  end
})

mytable.key1 = "new value"
mytable.key2 = 4

print(mytable.key1,mytable.key2)
--]]
----------------------------------



----------__addԪ������ʵ��������----------
--[[
function table_maxn(tablex)
	local maxn=0
	for i,v in pairs(tablex) do
		if maxn<i then
			maxn=i
		end
	end
	return maxn
end

table1=setmetatable({1,2,3},{__add=function(table1,table2)
										for i=1,table_maxn(table1) do
											table.insert(table1,table2[i])
										end
										return table1
									end
							})


table2={4,5,6}
table1=table1+table2
for i,v in ipairs(table1) do
	print(i,v)
end
--]]
--------------------------------------------



-----__callԪ�����൱�ڸ�������һ�ֺ���-----
--[[
table1=setmetatable({key1=1,key2=2,key3=3},{__call=
function(t,value)
	for i,v in pairs(t) do
		t[i]=t[i]+value
	end
	return t
end
})


table1(2)     	-- �ѱ�����һ��ʹ��
for i,v in pairs(table1) do
	print(i,v)
end
--]]
--------------------------------------------



----------__tostring�Զ��������-----------
--[[
table1=setmetatable({10,30,20,15},{__tostring=
function(t)
	local sum=0
	table.sort(t,function(n1,n2)
					return n1>n2
				end)
	for i,v in pairs(t) do
		print(i,v)
		sum=sum+v
	end
	return 'sum='..sum
end
})
print(table1)
--]]
--------------------------------------------






----------------------------------------Эͬ����-----------------------------------------

-- 1.Э�̲�ͬ���̣߳�ͬһʱ��ֻ��һ��Э�������У�Э��ֱ�������л����໥Эͬ
-- 2.�һ��˺ܳ�ʱ�������resume��yield�ĸ���ͻ��ƣ���ʵ����������Э�̵Ĺؼ���
-- 3.�ص����resume��yield��Ĳ������ݷ�ʽ������������Ӻ��ܽ����Ѿ���ϸ��¼��

-----------------------------------------------------------------------------------------



----------Э��coroutine�������-----------
--[[
--(1)
print("----(1)try coroutine.create----")
co=coroutine.create(   				-- coroutine.create����Э�̣�����Э�̱���(thread����)
	function(i)
		print(i)
	end
)

coroutine.resume(co,1)
coroutine.resume(co,2)  			-- ���е�endЭ�̾�down�ˣ���˱���resume��Ч
print('show coroutine status:'..coroutine.status(co))

--(2)
print("----(2)try coroutine.wrap----")
co=coroutine.wrap( 				 	-- coroutine.wrap����Э�̣����غ��������øú���ʱ����Э��
	function(i)
		print(i)
	end
)

co(1)

--(3)
print("----(3)resume&yield----")
co2=coroutine.create(
	function()
		for i=1,10 do
			print(i)
			if i==3 then
				print('��ʱco2��״̬��'..coroutine.status(co2))
				print(coroutine.running())
			end
			coroutine.yield()
		end
	end
)

coroutine.resume(co2)
coroutine.resume(co2)
coroutine.resume(co2)

print('��ʱco2��״̬��'..coroutine.status(co2))
print(coroutine.running()) 			 -- �������nil������վ�ϵĽ������
--]]
---------------------------------------



---------resume��yield֮���������-----------
--[[
-- ���²��Ľ��ü�����Ҫ:http://blog.chinaunix.net/uid-20225489-id-219322.html
-- ���²��Ľ��ıȽϾ��壬Ҳ����http://blog.csdn.net/boshuzhang/article/details/56013497

co=coroutine.create(
	function(a,b)
		for i=1,2,1 do
			print('yield\'s return is:',coroutine.yield('yiled\'s arg'..i))
		end
	end
)

print('-----------------------')
arg1,arg2=coroutine.resume(co,1,2) 			-- ��һ��resume����������coroutine�������򣨶�����yield��������coroutineֱ��yield��resume��ȡyield�Ĳ�����Ϊ�Լ��ĵڶ�������ֵ
print('resume\'s second return is:',arg2)
arg1,arg2=coroutine.resume(co,3,4,5)        -- �ڶ���resume������yield������Ҳ����yield����һ�ε�yield��ȡresume�Ĳ�����Ϊ�Լ��ķ���ֵ��ע���ǵڶ���resume�Ĳ�������resume��ȡ�ڶ���yield�Ĳ�����Ϊ�Լ��ķ���ֵ
print('resume\'s second return is:',arg2)
print('-----------------------')
--]]
----------------------------------------------



-------resume��yield֮��Ĳ�������2-------
--[[
function foo (a)
    print("foo �������Ϊ��", a)
    return coroutine.yield(2 * a)  				-- resume1��yield1�����ｫЭ�̹���resume1��ȡyield1�Ĳ��� 2*a=4 ��Ϊ����ֵ����yield1����return�����ǵȴ�resume2���ѣ���ȡ���Ĳ�����Ϊ����ֵ
end


co = coroutine.create(function (a , b)
    print("��һ��ִ��Э�̣�\nresume1�Ĳ���Ϊ��", a, b)
    local r = foo(a + 1)
	print('yield1�ķ���ֵΪ:',r)  				-- �����yield1֮��yield2֮ǰ�����Կ�����yield1�ķ���ֵ��resume2�Ĳ���

    print("�ڶ���ִ��Э�̣�\nresume2�Ĳ���Ϊ��",r)
    local r, s = coroutine.yield(a + b, a - b)  -- yield2��Э�̹���yield2�Ĳ���(a+1,a-b)����resume2��Ϊ����ֵ��yield2�ȴ�resume3���Ѻ��ٽ�����ֵ����r��s
	print('yield2�ķ���ֵΪ��',r,s)
	print("������ִ��Э�̣�\nresume3�Ĳ���Ϊ��",r, s)
    return b, "����Эͬ����"                   	-- Э�̽�����co�ķ���ֵ����Ϊresume3�ķ���ֵ
end)


print("---�ָ���----")
print("resume1����ֵ��", coroutine.resume(co, 1, 10)) 			-- resume1,����coЭ�̣�����(1,10)���ccoroutine����������yield1��ȥyield1�Ĳ�����Ϊ����ֵ
print("---�ָ���----")
print("resume2����ֵ��", coroutine.resume(co, "arg of resume2")) -- resume2������yield1����ʹyield1���أ�����ֵΪresume2�Ĳ�����resume2��yield2�Ĳ�����Ϊ�Լ��ķ���ֵ
print("---�ָ���----")
print("resume3����ֵ��", coroutine.resume(co, "arg of resume3.1", "arg of resume3.2")) -- resume3����yield2�����ڻ��Ѻ�Э��ֱ�����н����ˣ����resume3ȡco�ķ���ֵ��Ϊ�Լ��ķ���ֵ
print("---�ָ���----")
print("resume4����ֵ��", coroutine.resume(co, "x", "y")) 	-- ����Э���Ѿ�dead�����resume4������false
print("---�ָ���----")
--]]
-------------------------------------------



----------resume & yield �ܽ�-------------
--[[
print('-----resume & yield �ܽ�-----')
print('resumeʵ�֣�')
print('1.��һ��resume������Э��������')
print('2.�ǵ�һ��resume������ǰһ��yield')
print('3.ִ��Э��ֱ���µ�yield��ȡ��yield�Ĳ���Ϊ����')
print('4.resume��Э�����е����ˣ���ȡЭ�̵ķ���ֵΪresume�ķ���ֵ')
print('5.resume�Ѿ�dead��Э�̣�����false�ʹ�����ʾ\n')

print('yieldʵ�֣�')
print('1.����Э�̣���yield�Ĳ�����Ϊresume�ķ���ֵ�������̣��ȴ��µ�resume����')
print('2.���µ�resume�����ȡ��resume�Ĳ���Ϊ����ֵ��ͨ�����������������ʹ�ã�,����ִ��Э��')
print('------------------------------')
--]]
-------------------------------------------



---------��������-�����ߡ�����----------
--[[
local newProductor

function productor()
     local i = 0
     while true do
          i = i + 1   -- ��������
          send(i)     -- ������Э��ֹͣ���������𣩣�����Ʒ����yield�����ﴫ�ݸ����������̣��ȴ�������������һ������resume��
     end
end

function consumer()
     while true do
          local i = receive()     -- ������Э����Ϊ���̣�����������Э�̣���ȡ��Ʒ��yield�Ĳ�����
          print(i)
     end
end

function receive()
     local status, value = coroutine.resume(newProductor)
     return value
end

function send(x)
     coroutine.yield(x)
end

-- ��������
newProductor = coroutine.create(productor) -- ����������Э��newProductor
consumer()
--]]
----------------------------------------







-------------------------------------------�ļ�I/O--------------------------------------------

-- �ļ�I/O�Ƚ����ף�������Ϊû��Ҫ���̳���ķ�Ϊʲô����ģʽ��������ȫģʽ��������ͨ�õĶ����ã���ס
-- ϸ΢�Ĳ����С��ص���Ҫ��ס�������ú���

----------------------------------------------------------------------------------------------



-----------------�ļ�I/O------------------
--[[
-- һЩ������IO��������Ҫ����io.open��io.close��io.read��io.write��Щ��Ҫ��
-- ���⻹��io.type��io.lines��io.tmpfile��io.seek�ȣ�û�е������У��ڳ���Ƭ���õ�
--��ϸ��http://www.cnblogs.com/chiguozi/p/5804951.html

print('-------io.read���ļ�-------')
file=io.open('testIO.txt')
print(io.type(file))	-- ����ļ�����Ƿ���ã�����ֵ��file��closed file��nil����
print(file:read('*n'))	-- ��ȡһ�����֣�Ҳ�����ǡ�*num����'*number'
print(file:read()) 		-- �޲���Ĭ�϶�һ�У�*n��һ�����֣�*l����һ�У�*a��ȫ�����������ȡָ���ֽ���
io.input(file) 			-- ����Ĭ�������ļ�ΪtestIO.txt
print(io.read()) 		-- ��Ĭ���ļ���ȡ��һ��
print(io.read('*a'))	-- ��ȡ�ļ���������
io.close(file)
print(io.type(file))

print('-------io.lines���ļ�-------')
print('����Ϊ����io.lines()�������')
for str in io.lines('testIO.txt') do  -- io.lines()����һ������������ÿ��ִ�иõ��������������ļ���һ��
	print(str)
end
print(io.type(file))				  -- ��������nilʱ���Զ��ر��ļ�

print('\n')

file=io.open('testIO.txt')
print('����Ϊ����file:lines()�������')
for str in file:lines() do
	print(str)
end
print(io.type(file))				  -- ʹ���ļ��������ʱ�������ڶ�ȡ�������ݺ��Զ��ر��ļ�
io.close(file)
--[[
print('-------io.writeд�ļ�-------')
file=io.open('testIO.txt','a')
io.output(file)
io.write('\n���Ը��ӷ�ʽ��ֻд�ļ��������ļ������һ�м�����仰')
io.close(file)
--]]
print('-------tmpfile��д�ļ�--------')
tempfile=io.tmpfile()				  -- ������ʱ�ļ�����������r+��ʽ�򿪣��Ͼ��ɶ���д��
tempfile:write('��ʱ�ļ���һ��\n')
tempfile:write('��ʱ�ļ��ڶ���\n')
tempfile:write('��ʱ�ļ�������\n')

os.execute("pause")
tempfile:seek('set')				  -- �ļ�ָ���Ƶ���ͷ��'cur'Ϊ��ǰλ�ã���end��Ϊ�ļ�β������ֵΪ���ֽڵ��ļ�λ��
print(tempfile:read('*a'))
-- ���������ʱ�򣬸���ʱ�ļ����Զ�ɾ����
--]]
------------------------------------



































