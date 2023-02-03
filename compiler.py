# Python code to convert assembly to machine code


  
# Using readlines()
file_r = open('input.txt', 'r')
file_w = open('output.txt', 'w')

Lines = file_r.readlines()
gotos = {}
counter = 0
for line in Lines:
    line = line.strip().rstrip("\n").upper()
    words = line.split(' ')
    opcode = words[0]
    if opcode == "":
        continue
    match opcode:
        case 'ADD':
            counter += 1
        case 'SUB':
            counter += 1
        case 'FLC':
            counter += 1
        case 'MOV':
            counter += 1
        case 'CAE':
            counter += 1
        case 'PASS':
            counter += 1
        case 'JMPZ':
            counter += 1
            counter += 1
            counter += 1
        case 'AND':
            counter += 1
        case 'GOTO':
            counter += 1
            counter += 1
            counter += 1
            counter += 1
        case 'GOTOZ':
            counter += 1
            counter += 1
            counter += 1
        case other:
            gotos[opcode.rstrip(":")] = counter



print("Gotos:", gotos)

file_r = open('input.txt', 'r')
Lines = file_r.readlines()
counter = 0
for line in Lines:
    line = line.strip().rstrip("\n").upper()
    words = line.split(' ')
    print(words)
    opcode = words[0]
    if opcode == "":
        continue
    match opcode:
        case 'ADD':
            dest = int(words[1][1:])
            r1 = int(words[2][1:])
            imm = int(words[3])
            file_w.write('Data_Rom({:d}) <= \"000{:04b}{:04b}{:08b}0000\";\n'.format(counter,dest,r1,imm))
            counter += 1
        case 'SUB':
            dest = int(words[1][1:])
            r1 = int(words[2][1:])
            imm = int(words[3])
            file_w.write('Data_Rom({:d}) <= \"001{:04b}{:04b}{:08b}0000\";\n'.format(counter,dest,r1,imm))
            counter += 1
        case 'FLC':
            dest = int(words[1][1:])
            r1 = int(words[2][1:])
            r2 = int(words[3][1:])
            imm = int(words[4])
            file_w.write('Data_Rom({:d}) <= \"010{:04b}{:04b}{:04b}{:08b}\";\n'.format(counter,dest,r1,r2,imm))
            counter += 1
        case 'MOV':
            dest = int(words[1][1:])
            imm = int(words[2])
            file_w.write('Data_Rom({:d}) <= \"011{:04b}{:08b}00000000\";\n'.format(counter,dest,imm))
            counter += 1
        case 'CAE':
            dest = int(words[1][1:])
            r1 = int(words[2][1:])
            r2 = int(words[3][1:])
            file_w.write('Data_Rom({:d}) <= \"100{:04b}{:04b}{:04b}00000000\";\n'.format(counter,dest,r1,r2))
            counter += 1
        case 'PASS':
            file_w.write('Data_Rom({:d}) <= \"10100000000000000000000\";\n'.format(counter))
            counter += 1
        case 'JMPZ':
            dest = int(words[1][1:])
            file_w.write('Data_Rom({:d}) <= \"110{:08b}000000000000\";\n'.format(counter,dest))
            counter += 1
            file_w.write('Data_Rom({:d}) <= \"10100000000000000000000\";\n'.format(counter))
            counter += 1
            file_w.write('Data_Rom({:d}) <= \"10100000000000000000000\";\n'.format(counter))
            counter += 1
        case 'AND':
            dest = int(words[1][1:])
            r1 = int(words[2][1:])
            imm = int(words[3])
            file_w.write('Data_Rom({:d}) <= \"111{:04b}{:04b}{:08b}0000\";\n'.format(counter,dest,r1,imm))
            counter += 1
        case 'GOTO':
            dest = gotos[words[1]]
            file_w.write('Data_Rom({:d}) <= \"01111010000000000000000\";\n'.format(counter))
            counter += 1
            file_w.write('Data_Rom({:d}) <= \"110{:08b}000000000000\";\n'.format(counter,dest))
            counter += 1
            file_w.write('Data_Rom({:d}) <= \"10100000000000000000000\";\n'.format(counter))
            counter += 1
            file_w.write('Data_Rom({:d}) <= \"10100000000000000000000\";\n'.format(counter))
            counter += 1
        case 'GOTOZ':
            dest = gotos[words[1]]
            file_w.write('Data_Rom({:d}) <= \"110{:08b}000000000000\";\n'.format(counter,dest))
            counter += 1
            file_w.write('Data_Rom({:d}) <= \"10100000000000000000000\";\n'.format(counter))
            counter += 1
            file_w.write('Data_Rom({:d}) <= \"10100000000000000000000\";\n'.format(counter))
            counter += 1
        case other:
            assert(gotos[opcode.rstrip(":")] == counter)




print("Finished decoding")
input()
