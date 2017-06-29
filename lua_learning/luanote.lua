-- Allen的lua学习笔记

-- 使用SciTE编辑器遇到中文乱码，解决方法参照：http://blog.csdn.net/yao_yu_126/article/details/8661988

-- Scite的其他配置参考：http://www.360doc.com/content/11/0223/12/496343_95360892.shtml
--							   以及：https://my.oschina.net/mickelfeng/blog/199938



---------------------------------------基本函数----------------------------------------------

-- 一些基本函数的学习，包括跨文件调用函数、匿名函数、闭包等

---------------------------------------------------------------------------------------------



---------函数调用----------
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



-----dofile方法调用其他文件中的函数-----
--[[
dofile("math1.lua")

print("Please input two numbers\n")
a=io.read("*number")
b=io.read("*number")

n=sum_of_squares(a,b)

print(a.."^2 +"..b.."^2 ="..n)
--]]
----------------------------------------



-------函数传递给参数-------
--[[
fun1=function(n1,n2)
	sum=n1+n2
	print(sum)
end

fun1(1,2)
--]]
----------------------------



-----匿名函数作为函数参数传递-----
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



--------函数参数数目不定--------
--[[
function average(...) 					-- ...表示参数个数不定
   result = 0
   local arg={...}
   for i,v in ipairs(arg) do
      result = result + v
   end
   print("总共传入 " .. #arg.. " 个数")	-- #table返回参数个数
   return result/#arg
end

print("平均值为",average(10,5,3,4,5,6))
--]]
--------------------------------



----------闭包试例----------
--[[
    function test()
        local i=0
        return function()
            i=i+1
            return i
        end
    end
    c1=test()
    c2=test()			-- c1,c2是建立在同一个函数，同一个局部变量的不同实例上面的两个不同的闭包
						-- 闭包中的upvalue各自独立，调用一次test()就会产生一个新的闭包
    print(c1()) 		-->1
    print(c1()) 		-->2    重复调用时每一个调用都会记住上一次调用后的值，就是说i=1了已经
    print(c2())   	   	-->1    闭包不同所以upvalue不同
    print(c2())			-->2
--]]
-----------------------------



--------字符串搜索---------
--[[
start,end1=string.find("Hello Lua user", "Lua",7)	-- 第三个参数是开始搜索的位置
print(start,end1)
--]]
---------------------------



--------按格式输出---------
--[[
f=3
print(string.format("%05.3d",f))	-- %05.3d，05表示占位5，不足左侧补零，.3表示小数点后保留3位
--]]
---------------------------







-----------------------------------------------迭代器--------------------------------------------------

-- 关于迭代器的内容，网上的教程普遍没讲清楚，很多概念混淆在一起，尤其是分类
-- 以下博文讲得相对比较好：http://www.cnblogs.com/Richard-Core/p/4343635.html
-- 有必在此基础上明确分类和说明如下：
-- 1.迭代器按【实现迭代的语法】可分为泛型for迭代器、while迭代器等，泛型for用的比较多
-- 2.迭代器按【自身是否保存状态】可分为无状态迭代器、多状态迭代器
-- 3.无状态迭代器每次迭代都需要手动传入控制变量，输入的控制变量决定当次迭代的输出（输入决定输出）
-- 4.多状态迭代器自身保存状态，每次迭代时由当前状态决定输出，因此往往不需要控制变量（状态决定输出）
-- 5.多状态迭代器可以用闭包实现（upvalue保存状态），也可以把状态信息存在状态常量里（一个表），
--	 每次迭代修改状态常量，实现状态切换
-- 6.泛型for迭代器实现时，优先选择无状态迭代器，开销最小

-------------------------------------------------------------------------------------------------------



---------默认迭代器---------
--[[
tab1={key1="val1",key2="val2","val3"}
for k,v in pairs(tab1) do  -- pairs(table)列出table中的所有元素，无论索引是序号还是其它
	print(k..':'..v)
end

print('-------分隔线-------')

tab1.key1=nil              -- 释放索引key1
for k,v in pairs(tab1) do
	print(k..':'..v)
end
--]]
----------------------------



--------泛型for迭代器-------
--[[
-- 1.泛型for迭代需要三个参数：迭代函数、状态常量、控制变量。迭代时，将状态常量和控制变量传入迭代函数运行
-- 2.在无状态迭代器中，状态常量和状态无关，往往只是一个要用到的常量（需要迭代的表、控制迭代次数的常量）
-- 3.在多状态迭代器中，状态常量中可用于保存状态信息，并在迭代过程中实时修改（当然也可以用闭包）
-- 4.状态常量这个名字给我的理解带来了很大困扰，根据以上两条，我认为叫“状态常量”似乎并不合适，首先它
--	 不一定记录状态，其次它并不是常量。
-- 5.泛型for迭代在返回的第一个参数为nil时停止迭代，

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



---------无状态迭代器--------
--[[
-- 事实上，上例也是无状态迭代器
function iter (a, i)
    i = i + 1
    local v = a[i]
    if v then
       return i, v
    end
end

function ips (a)
    return iter,a,0  	-- 返回迭代函数iter，状态常量a，控制变量初始值1
end

a={"hello","lua","!"}
for i,v in ips(a) do 	-- for会执行ips，获取迭代函数iter、表a、控制变量（初始为0，迭代时会变）
	print(i,v)
end
--]]
-----------------------------



-----闭包实现多状态迭代器-----
--[[
function iterator(a)	-- 工厂函数
	local index=0    	-- 状态
	local count=#a    	--   	       \  闭包
	return function()	-- 闭包函数    /
				if index==0 then
					index=1
				elseif index==1 then
					index=3
				elseif index==3 then
					index=2
				elseif index==2 then
					index=4
				else
					index=nil 	-- a[nil]的值为空，传回时迭代停止
				end
				return a[index]
			end
end

table={'how','you','are','baby'}
for out in iterator(table) do		-- 这里只返回迭代函数（带状态的闭包），状态常量和控制变量补nil
	print(out)
end
-- 显然，这个例子难以用无状态迭代器实现
--]]
-------------------------------








--------------------------------------table---------------------------------------

-- table前面已经先用到了，这里进一步学习了一些常用的table操作函数
-- 另外，纯顺序数字索引的table也可称为数组

----------------------------------------------------------------------------------



----------表连接table.concat()----------
--[[
fruit={'apple','banana','orange'}
print('连接fruit表：',table.concat(fruit))
print('连接fruit表并用指定符号隔开：',table.concat(fruit,'（ToT）'))
print('指定表中连接的元素：',table.concat(fruit,',',2,3))    	-- 似乎第二个参数不能省略
--]]
----------------------------------------



-----------表排序table.sort()-----------
--[[
table1={19,21,32,45,76}
table.sort(table1,function(n1,n2)  	--表达式返回1时不换，返回0时交换
					return n1>n2
				  end)

for i,v in pairs(table1) do
	print(i,v)
end
--]]
----------------------------------------







-----------------------------------模块与包-----------------------------------------

-- 1.网上没有明确界定'模块'与‘包’，似乎lua写的叫模块，C写的叫包？姑且不做区分吧
-- 2.关于模块加载的搜索地址问题，也不做深究，简单地把拓展模块放在主程序一个目录下
-- 3.require和dofile加载方式的区别：
--	 1) dofile每次调用要重新加载、编译模块；require只需要加载一次，重复调用时会从已加载模块里读取；
--	 2)	require是进一步“包装”的loadfile（对于C包是loadlib）。loadfile（loadlib）仅加载模块，而
--      不运行，把整个模块文件当成一个函数返回，需要运行该函数才能调用模块内容；而require则是加载
--      并运行代码，直接可以调用模块内容
--	 3) require只需要文件名，dofile需要文件路径
-- 4.综合来说，无脑用require就行

--参考：http://blog.csdn.net/leecrest/article/details/31742419
--	    http://blog.csdn.net/u012861978/article/details/54667179

------------------------------------------------------------------------------------



--------用require调用文件--------
--[[
a1=require('test_require')   -- 一般要求被加载模块把函数都存在一个表了，返回这个表。不这样做也行，加载成功默认返回true，直接可以使用模块里的函数
print(type(a1))
print(a1.Fac(5))
print(a1.square(5))
--]]
--------------------------------








--------------------------------------元表metatable---------------------------------------

-- 1.关于元表metatable和元方法metamethod的概念我纠结了很久才明白，教程里对于元方法的作用，用“改
--   变表的行为”来描述，对于我这种初学者太抽象了。举例说明就要好理解很多：如果没有__index元方法，
--   那么引用一个表中不存在的键时，会返回nil；如果有__index元方法，此时就会去元方法的表中搜索该键，
--   所谓“改变表的行为”。
-- 2.元方法可以是一个表，也可以是一个函数

------------------------------------------------------------------------------------------



---------__index元方法---------
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
print(mytable.key2			)		-- 调用的键table里找不到，就去metatable中的__index键里找
									-- __index是函数，就把table和调用的键作为参数传进去执行该函数
print(mytable.key3)
--]]
-------------------------------



---------__newindex元方法--------
--[[
mymetatable={}
mytable=setmetatable({key1="value"},{__newindex=mymetatable})
print(mytable.key1)

mytable.newkey="新值2"
print(mytable.newkey,mymetatable.newkey)

mytable.key1="新值1"
print(mytable.key1,mymetatable.key1)
--]]
---------------------------------



------__newindex元方法为函数------
--[[
mytable = setmetatable({key1 = "value1"}, {
  __newindex = function(mytable, key, value)
		rawset(mytable, key, "\""..value.."\"")   -- rawset(表，键)用于跳过__newindex元方法进行赋值

  end
})

mytable.key1 = "new value"
mytable.key2 = 4

print(mytable.key1,mytable.key2)
--]]
----------------------------------



----------__add元方法，实现两表并联----------
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



-----__call元方法相当于给表定义了一种函数-----
--[[
table1=setmetatable({key1=1,key2=2,key3=3},{__call=
function(t,value)
	for i,v in pairs(t) do
		t[i]=t[i]+value
	end
	return t
end
})


table1(2)     	-- 把表像函数一样使用
for i,v in pairs(table1) do
	print(i,v)
end
--]]
--------------------------------------------



----------__tostring自定义表的输出-----------
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






----------------------------------------协同程序-----------------------------------------

-- 1.协程不同于线程，同一时刻只有一个协程在运行，协程直接来回切换，相互协同
-- 2.我花了很长时间来理解resume和yield的概念和机制，事实上它们正是协程的关键点
-- 3.重点理解resume和yield间的参数传递方式，在下面的例子和总结中已经详细记录了

-----------------------------------------------------------------------------------------



----------协程coroutine基础语句-----------
--[[
--(1)
print("----(1)try coroutine.create----")
co=coroutine.create(   				-- coroutine.create创建协程，返回协程本身(thread对象)
	function(i)
		print(i)
	end
)

coroutine.resume(co,1)
coroutine.resume(co,2)  			-- 运行到end协程就down了，因此本次resume无效
print('show coroutine status:'..coroutine.status(co))

--(2)
print("----(2)try coroutine.wrap----")
co=coroutine.wrap( 				 	-- coroutine.wrap创建协程，返回函数。调用该函数时唤醒协程
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
				print('此时co2的状态：'..coroutine.status(co2))
				print(coroutine.running())
			end
			coroutine.yield()
		end
	end
)

coroutine.resume(co2)
coroutine.resume(co2)
coroutine.resume(co2)

print('此时co2的状态：'..coroutine.status(co2))
print(coroutine.running()) 			 -- 这里输出nil，与网站上的结果不符
--]]
---------------------------------------



---------resume与yield之间参数传递-----------
--[[
-- 以下博文讲得简明扼要:http://blog.chinaunix.net/uid-20225489-id-219322.html
-- 以下博文讲的比较具体，也不错：http://blog.csdn.net/boshuzhang/article/details/56013497

co=coroutine.create(
	function(a,b)
		for i=1,2,1 do
			print('yield\'s return is:',coroutine.yield('yiled\'s arg'..i))
		end
	end
)

print('-----------------------')
arg1,arg2=coroutine.resume(co,1,2) 			-- 第一次resume，参数传给coroutine的主程序（而不是yield），运行coroutine直到yield，resume获取yield的参数作为自己的第二个返回值
print('resume\'s second return is:',arg2)
arg1,arg2=coroutine.resume(co,3,4,5)        -- 第二次resume，唤醒yield，参数也传给yield，第一次的yield获取resume的参数作为自己的返回值（注意是第二次resume的参数），resume获取第二次yield的参数作为自己的返回值
print('resume\'s second return is:',arg2)
print('-----------------------')
--]]
----------------------------------------------



-------resume和yield之间的参数传递2-------
--[[
function foo (a)
    print("foo 函数输出为：", a)
    return coroutine.yield(2 * a)  				-- resume1后，yield1在这里将协程挂起，resume1获取yield1的参数 2*a=4 作为返回值，但yield1不会return，而是等待resume2唤醒，获取它的参数作为返回值
end


co = coroutine.create(function (a , b)
    print("第一次执行协程：\nresume1的参数为：", a, b)
    local r = foo(a + 1)
	print('yield1的返回值为:',r)  				-- 这句在yield1之后、yield2之前，可以看出，yield1的返回值是resume2的参数

    print("第二次执行协程：\nresume2的参数为：",r)
    local r, s = coroutine.yield(a + b, a - b)  -- yield2将协程挂起，yield2的参数(a+1,a-b)传给resume2作为返回值，yield2等待resume3唤醒后，再将返回值传给r和s
	print('yield2的返回值为：',r,s)
	print("第三次执行协程：\nresume3的参数为：",r, s)
    return b, "结束协同程序"                   	-- 协程结束，co的返回值将作为resume3的返回值
end)


print("---分割线----")
print("resume1返回值：", coroutine.resume(co, 1, 10)) 			-- resume1,激活co协程，参数(1,10)传竎coroutine主程序，遇到yield1后去yield1的参数作为返回值
print("---分割线----")
print("resume2返回值：", coroutine.resume(co, "arg of resume2")) -- resume2，唤醒yield1并促使yield1返回，返回值为resume2的参数。resume2以yield2的参数作为自己的返回值
print("---分割线----")
print("resume3返回值：", coroutine.resume(co, "arg of resume3.1", "arg of resume3.2")) -- resume3唤醒yield2，由于唤醒后协程直接运行结束了，因此resume3取co的返回值作为自己的返回值
print("---分割线----")
print("resume4返回值：", coroutine.resume(co, "x", "y")) 	-- 由于协程已经dead，因此resume4将返回false
print("---分割线----")
--]]
-------------------------------------------



----------resume & yield 总结-------------
--[[
print('-----resume & yield 总结-----')
print('resume实现：')
print('1.第一次resume，激活协程主程序')
print('2.非第一次resume，唤醒前一次yield')
print('3.执行协程直到新的yield，取新yield的参数为返回')
print('4.resume后协程运行到底了，则取协程的返回值为resume的返回值')
print('5.resume已经dead的协程，返回false和错误提示\n')

print('yield实现：')
print('1.挂起协程，将yield的参数作为resume的返回值传回主程，等待新的resume激活')
print('2.被新的resume激活后，取新resume的参数为返回值（通常存入变量供接下来使用）,继续执行协程')
print('------------------------------')
--]]
-------------------------------------------



---------“生产者-消费者”问题----------
--[[
local newProductor

function productor()
     local i = 0
     while true do
          i = i + 1   -- 生产过程
          send(i)     -- 生产者协程停止生产（挂起），将产品放在yield参数里传递给消费者主程，等待消费者主程下一次需求（resume）
     end
end

function consumer()
     while true do
          local i = receive()     -- 消费者协程作为主程，唤醒生产者协程，获取产品（yield的参数）
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

-- 启动程序
newProductor = coroutine.create(productor) -- 创建生产者协程newProductor
consumer()
--]]
----------------------------------------







-------------------------------------------文件I/O--------------------------------------------

-- 文件I/O比较容易，个人认为没必要按教程里的分为什么‘简单模式’、‘完全模式’，当作通用的东西用，记住
-- 细微的差别就行。重点是要记住几个常用函数

----------------------------------------------------------------------------------------------



-----------------文件I/O------------------
--[[
-- 一些基本的IO操作，主要包括io.open、io.close、io.read、io.write这些主要的
-- 此外还有io.type、io.lines、io.tmpfile、io.seek等，没有单独罗列，在程序片中用到
--详细：http://www.cnblogs.com/chiguozi/p/5804951.html

print('-------io.read读文件-------')
file=io.open('testIO.txt')
print(io.type(file))	-- 检测文件句柄是否可用，返回值有file、closed file、nil三种
print(file:read('*n'))	-- 读取一个数字，也可以是‘*num’、'*number'
print(file:read()) 		-- 无参数默认读一行，*n读一个数字，*l读下一行，*a读全部，数字则读取指定字节数
io.input(file) 			-- 设置默认输入文件为testIO.txt
print(io.read()) 		-- 从默认文件读取下一行
print(io.read('*a'))	-- 读取文件所有内容
io.close(file)
print(io.type(file))

print('-------io.lines读文件-------')
print('以下为调用io.lines()的输出：')
for str in io.lines('testIO.txt') do  -- io.lines()返回一个迭代函数，每次执行该迭代函数，返回文件的一行
	print(str)
end
print(io.type(file))				  -- 迭代返回nil时，自动关闭文件

print('\n')

file=io.open('testIO.txt')
print('以下为调用file:lines()的输出：')
for str in file:lines() do
	print(str)
end
print(io.type(file))				  -- 使用文件句柄迭代时，不会在读取所有内容后自动关闭文件
io.close(file)

print('-------io.write写文件-------')
file=io.open('testIO.txt','a')
io.output(file)
io.write('\n我以附加方式打开只写文件，并在文件的最后一行加上这句话')
io.close(file)

print('-------tmpfile读写文件--------')
tempfile=io.tmpfile()				  -- 创建临时文件，好像是以r+方式打开（毕竟可读可写）
tempfile:write('临时文件第一行\n')
tempfile:write('临时文件第二行\n')
tempfile:write('临时文件第三行\n')

os.execute("pause")
tempfile:seek('set')				  -- 文件指针移到开头，'cur'为当前位置，‘end’为文件尾。返回值为按字节的文件位置
print(tempfile:read('*a'))
-- 程序结束的时候，该临时文件就自动删除了
--]]
------------------------------------





-------------------------------------------错误处理--------------------------------------------

-- 主要包括将错误信息直接抛出到console的assert、error函数
-- 以及封装错误信息的pcall、xpcall函数

-----------------------------------------------------------------------------------------------



-------------assert--------------
--[[
local function add(a,b)
   assert(type(a) == "number", "a 不是一个数字")   -- assert应该叫‘断言’吧，第一个参数为判断条件，第二个参数为错误反馈信息
   assert(type(b) == "number", "b 不是一个数字")
   return a+b
end
add(a,2)
--]]
---------------------------------



--------------error--------------
--[[
function test_error()
print('请输入一个数字：')
a=io.read('*n')

if type(a)~='number' then
	error('一定要输入数字哦！',0)  	-- 参数2控制输出错误信息时，在其前面增加的内容。	0：不输出错误位置   1：调用error的未知   2：指出调用error的函数（实测没什么用？）
else
	print('你输入的数字是：',a)
end
end

test_error()
--]]
---------------------------------



--------------pcall--------------
--[[
-- 调用格式：pcall(函数，参数)
-- 个人理解：protected call顾名思义，保护模式运行函数，如果出错不会抛出错误信息到console上，而是把错误信息封装进返回值传回。
-- 无错误，返回true。调用出错，返回(false,错误信息)，错误信息根据系统预置或assert、error自定义
-- 据说多用在与C的交互

function f(i)
--	if type(i)~='number' then
--		error('错错错！')
--	end
	assert(type(i)=='number','错错错！')
end

a,b=pcall(f,'a')
print(a,b)
--]]
---------------------------------



-------------xpcall--------------
--[[
-- xpcall在pcall的基础上追加传入一个错误处理函数，在错误处理函数中往往结合Debug库中的函数，输出调用信息。
-- 找到一个讲得比较清楚的：http://blog.csdn.net/zz7zz7zz/article/details/38848383

local fun=function ( ... )
--    local a=1;          -- 注释这里决定运行是否出错
    print(a+1);
   -- return a+1;
end

tryCatch=function(fun)
    local ret,errMessage=pcall(fun);
--	print('str' or true,type('str' or true))  	-- 逻辑运算符左边是str型：(str1 or str2/bool)=str1,（str1 and str2/bool）=str2/bool
												-- 逻辑运算符左边是bool型，逻辑优先级：nil < false < str < true
    print("ret:" .. (ret and "true" or "false" )  .. " \nerrMessage:" .. (errMessage or "null"));
end			-- 明明可以用tostring解决的问题，不知道这个例子为什么要用上述浮夸的逻辑运算实现，姑且当作一个小技巧记一下吧

xTryCatchGetErrorInfo=function()
    print(debug.traceback());		-- debug.traceback()根据调用栈来构建一个扩展的错误消息
end
xTryCatch=function(fun)
    local ret,errMessage=xpcall(fun,xTryCatchGetErrorInfo);
    print("ret:" .. (ret and "true" or "false" )  .. " \nerrMessage:" .. (errMessage or "null"));
end

print("\n------ pcall ------\n")
tryCatch(fun);

print("\n------ xpcall ------\n")
xTryCatch(fun);

print("\n--------------------\n")
--]]
---------------------------------










------------------------------------------------Debug-----------------------------------------------

-- 1.这里的Debug不同于以前学C时用IDE打断点调试，是一种在程序中添加调试函数来设定参数、获得反馈的调试方法
-- 2.调试函数多来自Debug库。Debug库的一个重要思想是栈级别(stack level),它用来表示活动函数（即正在运行，
--   还没有return的函数）的层级，Debug的库函数栈级别为0，调用库方法的函数a级别为1，调用函数a的函数级别为2，
--   以此类推

-- 不错的参考：http://blog.csdn.net/mydreamremindme/article/details/51211063
----------------------------------------------------------------------------------------------------



------默认栈跟踪函数 debug.traceback------
--[[
function myfunction()
	print(debug.traceback('栈跟踪',1))		-- debug库提供的默认栈跟踪函数,返回栈的回溯过程。
											-- 第一个参数是显示在最前面的文字，第二个参数是开始回溯的栈级
end

myfunction()
--]]
------------------------------------------



----利用debug.getinfo自写traceback函数----
--[[
function get_info()
	tab=debug.getinfo(1,'nSufl')			-- getinfo名为自省函数，返回指定栈级别中函数的信息表。参数1指定函数栈级别（函数名），参数2指定记录信息
	print('--以下是getinfo返回表的域--')
	print('name:',tab.name)					-- 函数名
	print('namewhat',tab.namewhat)			-- 表示上一个字符串是什么，'global' or 'local' or 'method' or 'field' or nil
	print('source:',tab.source)				-- 函数被定义的地方，@+文件名
	print('short_src:',tab.short_src)		-- source的简短版本（实际好像就是去掉@）
	print('linedefined:',tab.linedefined)	-- 函数被定义处的行号
	print('what:',tab.what)					-- 标明函数类型 ，'lua' or 'C' or 'main'
	print('nups:',tab.nups)					-- 函数upvalue的个数
	print('func:',tab.func)					-- 函数本身
	print('currentline',tab.currentline)	-- 这个时刻，函数所在的行号
	print('--------------------------')
end

function traceback()
	local level = 1
	while true do
		local info = debug.getinfo(level, "Sl") -- 栈级别1：traceback  栈级别2:main  栈级别3：？？？这个C函数是用C写的解释器？
		if not info then
			break
		end
		if info.what == "C" then
			print(level, "C function")
		else
			print(string.format("[%s]:%d",info.short_src, info.currentline))
		end
		level = level + 1
	end
end

get_info()
traceback()
--]]
------------------------------------------



-----getlocal & setlocal-----
--[[
-- getlocal和setlocal获得、设定活动函数的局部变量
function foo (a,b)
	local x
	do local c = a - b	-- do..end结构，显示定义变量的作用域
	end

	local a = 1
	while true do
		local name, value = debug.getlocal(1, a)  -- getlocal参数1：栈级别  参数2：局部变量索引    返回值1：变量名  返回值2：变量值
		if not name then
			break
		end
		print(name, value)
		a = a + 1
	end
	print('把索引为2的局部变量修改为100:')
	debug.setlocal(1,2,100)
	print(string.format('b的值变为：%d',b))
end

foo(10,20)
--]]
-----------------------------



------getupvalue & setupvalue------
--[[
-- 获得/设置闭包的upvalues，与局部变量不同的是，即使闭包不在活动状态，它依然有upvalues(因而不需要指定栈级别)
function newCounter()
	local n=0
	local k=0
	return function()
				k=n
				n=n+1
				return n
			end
end


counter=newCounter()
print(counter())
print(counter())

local i=1

repeat
	name,val=debug.getupvalue(counter,i)  		 -- 返回闭包counter的第i个upvalue的名字和值
	if name then
		print('index',i,name,'=',val)
			if name=='n' then
				debug.setupvalue(counter,2,10)   -- 将闭包counter的第二个upvalue（即k）设为10
			end
		i=i+1
	end
until not name

print(counter())
--]]
-----------------------------------



----只知道变量名，要找到这个变量----

-- 1.首先怀疑是某个函数的局部变量，用debug.getlocal(1，index)查找
-- 2.其次怀疑是这个函数所在闭包的upvalue，用debug.getupvalue(func)查找,func通过getinfo(2).func获取
-- 3.最后怀疑是全局变量，用debug.getfenv(func)查找

-----------------------------------


------sethook & gethook------
--[[
-- 钩子的目的：监控call、return、line、count事件
-- sethook(hook_function,event)    hook_function:钩子函数，event发生时调用；event被监视的事件
-- call：调用函数时发生；return：函数返回时发生；line:执行新行代码时发生；

function trace(event,line) -- 钩子函数接收：参数1事件、参数2行号(只有line事件有)
	local s=debug.getinfo(2).short_src
	print(s..':'..line)
end
print('----sethook----')
debug.sethook(trace,'l')
print('hello')
print(debug.gethook(1))		-- 查看指定栈级别下的钩子，返回值为 [钩子函数，钩子掩码，钩子计数]
print('lua')
debug.sethook()
print('!')
print('---------------')

-- ‘可选的第三个参数是一个数字，描述我们打算获取 count事件的频率’没太明白
--]]
-----------------------------












------------------------------------------------垃圾回收--------------------------------------------------

-- 1.垃圾收集器间歇率，控制新一轮垃圾收集前要等待多久，100以内无等待，200表示内存使用翻倍时启动垃圾收集
-- 2.垃圾收集器步进倍率，控制收集器运行速度相对于内存分配速度的倍率，默认200表示垃圾收集速度是内存分配速度的两倍
-- 3.垃圾收集器步长，一轮垃圾收集中，一次迭代跨越的内存数
-- 4.lua的垃圾收集自动完成，也可以手动用collectgarbage('collect')显式回收
-- 5.对垃圾回收器的设置也用collectgarbage完成

-- 参考：http://wiki.jikexueyuan.com/project/lua/garbage-collection.html
-- 		 http://colen.iteye.com/blog/578146

----------------------------------------------------------------------------------------------------------



-----collectgarbage-----

mytable = {"apple", "orange", "banana"}

print('count1:',collectgarbage("count"))		-- 返回当前程序使用的内存总量，以KB为单位

mytable = nil

print('count2:',collectgarbage("count"))

print(collectgarbage("collect"))				-- 运行一个完整的垃圾回收周期，返回值有什么含义？

print('count3:',collectgarbage("count"))		-- 显然，count2运行时，新一轮垃圾回收还没有启动，mytable的内存还没有被释放。到了count3，已经用collect显式启动回收，mytable的内存不复存在

-- collectgarbage('setpause',arg)				-- 修改间歇率
-- collectgarbage('setstepmul',arg)				-- 修改步进倍率
-- collectgarbage('step',arg)					-- 修改步长
-- collectgarbage('stop')
-- collectgarbage('restart')
------------------------



































