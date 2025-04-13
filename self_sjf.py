sample = [ [1 , 0 , 1] , [ 2 , 2 , 2] , [3 , 5 , 2]]
sample.sort(key=lambda x: (x[1], x[2])) 

ct = sample[0][1] + sample[0][2]
tat = ct - sample[0][1]
wt = tat - sample[0][2]
rt = ct - sample[0][1] - sample[0][2]
sample[0].extend([ct,tat,wt,rt])

atat = tat
awt = wt
art = rt
for i in range(1, len(sample)):
    if ct < sample[i][1]:
        ct = sample[i][1]  # CPU waits for the process to arrive
    ct += sample[i][2]
    sample[i].append(ct)
    tat = ct - sample[i][1]
    sample[i].append(tat)
    wt = tat - sample[i][2]
    sample[i].append(wt)
    rt = ct - sample[i][1] - sample[i][2]
    sample[i].append(rt)
    atat += tat
    awt += wt
    art += rt
sample.sort(key = lambda x: x[0])
# print(sample)
print(f"PID\tAT\tBT\tCT\tTAT\tWT\tRT")
for i in range(len(sample)):
    print(f"{sample[i][0]}\t{sample[i][1]}\t{sample[i][2]}\t{sample[i][3]}\t{sample[i][4]}\t{sample[i][5]}\t{sample[i][6]}")
    
print(f"Avg TAT: {atat/len(sample):.2f} ms")
print(f"Avg WT: {awt/len(sample):.2f} ms")
print(f"Avg RT: {art/len(sample):.2f} ms")