
table1={}

function table1.Fac(n)
    if n <= 1 then
        return n
    end
    return n * table1.Fac(n-1)
end

function table1.square(n)
	a=n*n
	return a
end

return table1




