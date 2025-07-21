#!/usr/bin/env python3

import matplotlib.pyplot as plt
from datetime import datetime
import sys

epic_completed = float(sys.argv[1])
task_completed = float(sys.argv[2])
today = datetime.today()
quarters = {
    1: (datetime(today.year, 1, 1), datetime(today.year, 3, 31)),
    2: (datetime(today.year, 4, 1), datetime(today.year, 6, 30)),
    3: (datetime(today.year, 7, 1), datetime(today.year, 9, 30)),
    4: (datetime(today.year, 10, 1), datetime(today.year, 12, 31)),
}
for q, (start, end) in quarters.items():
    if start <= today <= end:
        current_quarter = q
        start_date = start
        end_date = end
        break
days_elapsed = (today - start_date).days + 1
total_days = (end_date - start_date).days + 1
time_elapsed_percent = (days_elapsed / total_days) * 100
forecasted_completion = (epic_completed / time_elapsed_percent) * 100 if time_elapsed_percent > 0 else 0
task_forecasted_completion = (task_completed / time_elapsed_percent) * 100 if time_elapsed_percent > 0 else 0
plt.figure(figsize=(8, 6))
plt.plot([0, 100], [0, 100], 'k--', label='Ideal Progress (On Track)')
plt.plot([0, time_elapsed_percent], [0, epic_completed], 'bo-', label=f'Epic Progress ({epic_completed:.1f}%)')
plt.plot([0, time_elapsed_percent], [0, task_completed], 'go-', label=f'Task Progress ({task_completed:.1f}%)')
plt.plot([0, 100], [0, forecasted_completion], 'r:', label=f'Epic Forecast ({forecasted_completion:.1f}%)')
plt.plot([0, 100], [0, task_forecasted_completion], 'orange', linestyle=':', label=f'Task Forecast ({task_forecasted_completion:.1f}%)')
plt.scatter([time_elapsed_percent], [epic_completed], color='blue', s=100)
plt.scatter([time_elapsed_percent], [task_completed], color='green', s=100)
plt.title(f'Work Progress vs Time Elapsed – Q{current_quarter} {today.year}')
plt.xlabel('Time Elapsed (%)')
plt.ylabel('Work Completed (%)')
plt.xlim(0, 100)
plt.ylim(0, 100)
plt.grid(True)
plt.legend()
plt.axhline(y=epic_completed, color='lightblue', linestyle='--')
plt.axvline(x=time_elapsed_percent, color='lightblue', linestyle='--')
plt.tight_layout()
plt.show()
plt.ylabel('Work Completed (%)')
plt.xlim(0, 100)
plt.ylim(0, 100)
plt.grid(True)
plt.legend()
plt.axhline(y=epic_completed, color='lightblue', linestyle='--')
plt.axvline(x=time_elapsed_percent, color='lightblue', linestyle='--')
plt.tight_layout()
plt.show()
