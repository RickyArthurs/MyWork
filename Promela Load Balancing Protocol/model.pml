#define N 4

mtype { newTask, request, response }

chan taskChan[N] = [N] of { mtype };
chan queue = [3] of { chan, mtype };

int load[N] = {0, 5, 3, 1 };

proctype Client(int selfid) {
    int myLoad = load[selfid];
    int x, y; // variables to store neighbouring  values

    taskChan[selfid] ! newTask; //  load intial to own channel

    do
    :: queue ?? taskChan[selfid], response -> // check for messages from the global queue randomly
        myLoad++; //increase load value
        taskChan[selfid] ! newTask; // update value on own channel
    :: taskChan[(selfid + N - 1) % N] ?? x -> // poll the left neighbour channel randomly
        if
        :: (myLoad > x + 1) -> myLoad--; taskChan[selfid] ! newTask; queue ! taskChan[(selfid + N - 1) % N], request // send task to left neighbor
        :: else -> skip
        fi
    :: taskChan[(selfid + 1) % N] ?? y -> // poll the right neighbour channel randomly
        if
        :: (myLoad > y + 1) -> myLoad--; taskChan[selfid] ! newTask; queue ! taskChan[(selfid + 1) % N], request // send task to right neighbor
        :: else -> skip
        fi
    od
}

//(c)
never {
    // LTL property, to ensure the difference between adjacent loads remains within 1
    // iterate through each pair of neighbour clients and check the load difference
    // (b)
    do
    :: (1) ->
        // Ensure that load values stay within their specified ranges
        assert((load[0] >= 0) && (load[0] <= 100));
        ((load[0] >= load[1]) && (load[0] - load[1] <= 1)) || 
        ((load[0] < load[1]) && (load[1] - load[0] == 1))

        assert((load[1] >= 0) && (load[1] <= 100));
        ((load[1] >= load[2]) && (load[1] - load[2] <= 1)) || 
        ((load[1] < load[2]) && (load[2] - load[1] == 1))

        assert((load[2] >= 0) && (load[2] <= 100));
        ((load[2] >= load[3]) && (load[2] - load[3] <= 1)) || 
        ((load[2] < load[3]) && (load[3] - load[2] == 1))

        assert((load[3] >= 0) && (load[3] <= 100));
        ((load[3] >= load[0]) && (load[3] - load[0] <= 1)) || 
        ((load[3] < load[0]) && (load[0] - load[3] == 1))
    od
}

init {
    int i;
    run Client(0);
    run Client(1);
    run Client(2);
    run Client(3);
    
    // Load array
    for (i : 0..3) {
        assert((load[i] >= 0) && (load[i] <= 100));
        taskChan[i] ! load[i];
    }
}
