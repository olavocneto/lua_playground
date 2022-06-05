copas = { 1958, 1962, 1970, 1994, 2022 }

print(#copas)

print(copas[2])

for i = 1, #copas do
    print(copas[i])
end

for index, value in ipairs(copas) do
    print(index, value)
end

idades = { 20, 42, 54, 57, 11 }

print(idades[1])
print(idades[4])

idades = { 20, 42, 54 }

idades[5] = 19

print(#idades)
print(idades[4])

aluno = {
    ["idade"] = 23,
    ["nome"] = "Barney"
}

print(aluno["nome"])
print(aluno["idade"])

print('-----------------------------')

idades = { 20, 42, 54, 57, 11, 30, 18 }

for i, idade in ipairs(idades) do 
    print(i, idade)
end