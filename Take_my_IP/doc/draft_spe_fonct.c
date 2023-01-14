const int NB_ID = 4;

int highest_prio = 0;
int id_must_prio = 0;

int i = 0;
// Second prio encoder will keep higher id the for loop needs to end with high id
for (i = 0; i < NB_ID; i++) {
    if ((priority_vector(j) >= highest_prio) & (nIT_xxx(j) == true)) {
        highest_prio = priority_vector(j);
        id_must_prio = j;
    }
}


// no loop approche

int highest_prio = 0;
int id_must_prio = 0;

if ((priority_vector(0) >= highest_prio) & (nIT_xxx(0) == true)) {
    highest_prio = priority_vector(0);
    id_must_prio = j;
}