def sjf_scheduling(processes):
    processes.sort(key=lambda x: (x[1], x[2]))  # Sort by arrival time, then burst time
    
    current_time, total_wait, total_turnaround = 0, 0, 0
    gantt_chart = []
    
    print("Process\tArrival Time\tBurst Time\tWaiting Time\tTurnaround Time\tCompletion Time")
    
    for pid, arrival, burst in processes:
        if current_time < arrival:
            current_time = arrival
        
        wait_time = current_time - arrival
        turnaround_time = wait_time + burst
        completion_time = current_time + burst
        
        total_wait += wait_time
        total_turnaround += turnaround_time
        
        print(f"{pid}\t{arrival}\t\t{burst}\t\t{wait_time}\t\t{turnaround_time}\t\t{completion_time}")
        gantt_chart.append((pid, current_time, completion_time))
        
        current_time += burst
    
    print(f"\nAvg Waiting Time: {total_wait / len(processes):.2f}")
    print(f"Avg Turnaround Time: {total_turnaround / len(processes):.2f}")
    
    # Gantt Chart in Terminal
    print("\nGantt Chart:")
    print("|", end="")
    for task in gantt_chart:
        print(f" P{task[0]} |", end="")
    print()
    print("0", end="")
    for task in gantt_chart:
        print(f"   {task[2]}", end="")
    print()

# Example usage
sjf_scheduling([(1, 0, 6), (2, 2, 8), (3, 4, 7), (4, 5, 3)])
