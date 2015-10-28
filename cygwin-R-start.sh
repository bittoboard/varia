#!/bin/bash 

MAX_TASKS=4

declare -A tasks;
tasks[1]="1.bat"
tasks[2]="2.bat"
tasks[3]="3.bat"
tasks[4]="4.bat"

EXPLORER_CYGPATH=`which explorer`
EXPLORER_WINPATH=`cygpath --windows --absolute "${EXPLORER_CYGPATH}"`

task_id=1;
while [ TRUE ]; do
    total_tasks=$(ps -aW | grep Rscript | wc -l);
    total_tasks=$(expr $total_tasks / 2);   # One instance creates 2 Rscript processes
    echo "There are $total_tasks tasks running ..."
        
    if [ "$total_tasks" -lt "$MAX_TASKS" ]; then
        while [[ "$task_id" -le "${#tasks[@]}" && ( "${tasks[$task_id]}" == "" || -e "${tasks[$task_id]}.done" ) ]]; do 
            task_id=$(expr $task_id + 1);
        done
        
        if [[ "$task_id" -le "${#tasks[@]}" && -n "${tasks[$task_id]}" ]]; then 
            task=${tasks[$task_id]}
            curtime=$(date)
            echo "Starting new task at $curtime: $task"
            SCRIPT_WINPATH=`cygpath --windows --absolute "$task"`
            SCRIPT_STARTDIR=`cygpath --windows --absolute $(pwd)`
            SCRIPT_LOGPATH="${SCRIPT_WINPATH}.log"
            cmd /C start "R script" "${SCRIPT_WINPATH}"         
            task_id=$(expr $task_id + 1);
        else
            echo "There are no more tasks to add. Quitting."
            exit 0
        fi
    fi
    sleep 5
done

exit 0
