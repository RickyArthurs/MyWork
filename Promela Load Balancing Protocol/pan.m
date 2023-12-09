#define rand	pan_rand
#define pthread_equal(a,b)	((a)==(b))
#if defined(HAS_CODE) && defined(VERBOSE)
	#ifdef BFS_PAR
		bfs_printf("Pr: %d Tr: %d\n", II, t->forw);
	#else
		cpu_printf("Pr: %d Tr: %d\n", II, t->forw);
	#endif
#endif
	switch (t->forw) {
	default: Uerror("bad forward move");
	case 0:	/* if without executable clauses */
		continue;
	case 1: /* generic 'goto' or 'skip' */
		IfNotBlocked
		_m = 3; goto P999;
	case 2: /* generic 'else' */
		IfNotBlocked
		if (trpt->o_pm&1) continue;
		_m = 3; goto P999;

		 /* PROC :init: */
	case 3: // STATE 1 - model.pml:61 - [(run Client(0))] (0:0:0 - 1)
		IfNotBlocked
		reached[2][1] = 1;
		if (!(addproc(II, 1, 0, 0)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 4: // STATE 2 - model.pml:62 - [(run Client(1))] (0:0:0 - 1)
		IfNotBlocked
		reached[2][2] = 1;
		if (!(addproc(II, 1, 0, 1)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 5: // STATE 3 - model.pml:63 - [(run Client(2))] (0:0:0 - 1)
		IfNotBlocked
		reached[2][3] = 1;
		if (!(addproc(II, 1, 0, 2)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 6: // STATE 4 - model.pml:64 - [(run Client(3))] (0:0:0 - 1)
		IfNotBlocked
		reached[2][4] = 1;
		if (!(addproc(II, 1, 0, 3)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 7: // STATE 5 - model.pml:67 - [i = 0] (0:0:1 - 1)
		IfNotBlocked
		reached[2][5] = 1;
		(trpt+1)->bup.oval = ((P2 *)_this)->i;
		((P2 *)_this)->i = 0;
#ifdef VAR_RANGES
		logval(":init::i", ((P2 *)_this)->i);
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 8: // STATE 6 - model.pml:67 - [((i<=3))] (0:0:0 - 1)
		IfNotBlocked
		reached[2][6] = 1;
		if (!((((P2 *)_this)->i<=3)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 9: // STATE 7 - model.pml:68 - [assert(((load[i]>=0)&&(load[i]<=100)))] (0:0:0 - 1)
		IfNotBlocked
		reached[2][7] = 1;
		spin_assert(((now.load[ Index(((P2 *)_this)->i, 4) ]>=0)&&(now.load[ Index(((P2 *)_this)->i, 4) ]<=100)), "((load[i]>=0)&&(load[i]<=100))", II, tt, t);
		_m = 3; goto P999; /* 0 */
	case 10: // STATE 8 - model.pml:69 - [taskChan[i]!load[i]] (0:0:0 - 1)
		IfNotBlocked
		reached[2][8] = 1;
		if (q_full(now.taskChan[ Index(((P2 *)_this)->i, 4) ]))
			continue;
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[64];
			sprintf(simvals, "%d!", now.taskChan[ Index(((P2 *)_this)->i, 4) ]);
		sprintf(simtmp, "%d", now.load[ Index(((P2 *)_this)->i, 4) ]); strcat(simvals, simtmp);		}
#endif
		
		qsend(now.taskChan[ Index(((P2 *)_this)->i, 4) ], 0, now.load[ Index(((P2 *)_this)->i, 4) ], 0, 1);
		_m = 2; goto P999; /* 0 */
	case 11: // STATE 9 - model.pml:67 - [i = (i+1)] (0:0:1 - 1)
		IfNotBlocked
		reached[2][9] = 1;
		(trpt+1)->bup.oval = ((P2 *)_this)->i;
		((P2 *)_this)->i = (((P2 *)_this)->i+1);
#ifdef VAR_RANGES
		logval(":init::i", ((P2 *)_this)->i);
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 12: // STATE 15 - model.pml:71 - [-end-] (0:0:0 - 3)
		IfNotBlocked
		reached[2][15] = 1;
		if (!delproc(1, II)) continue;
		_m = 3; goto P999; /* 0 */

		 /* CLAIM never_0 */
	case 13: // STATE 2 - model.pml:41 - [assert(((load[0]>=0)&&(load[0]<=100)))] (0:0:0 - 1)
		
#if defined(VERI) && !defined(NP)
#if NCLAIMS>1
		{	static int reported2 = 0;
			if (verbose && !reported2)
			{	int nn = (int) ((Pclaim *)pptr(0))->_n;
				printf("depth %ld: Claim %s (%d), state %d (line %d)\n",
					depth, procname[spin_c_typ[nn]], nn, (int) ((Pclaim *)pptr(0))->_p, src_claim[ (int) ((Pclaim *)pptr(0))->_p ]);
				reported2 = 1;
				fflush(stdout);
		}	}
#else
		{	static int reported2 = 0;
			if (verbose && !reported2)
			{	printf("depth %d: Claim, state %d (line %d)\n",
					(int) depth, (int) ((Pclaim *)pptr(0))->_p, src_claim[ (int) ((Pclaim *)pptr(0))->_p ]);
				reported2 = 1;
				fflush(stdout);
		}	}
#endif
#endif
		reached[1][2] = 1;
		spin_assert(((now.load[0]>=0)&&(now.load[0]<=100)), "((load[0]>=0)&&(load[0]<=100))", II, tt, t);
		_m = 3; goto P999; /* 0 */
	case 14: // STATE 3 - model.pml:43 - [((((load[0]>=load[1])&&((load[0]-load[1])<=1))||((load[0]<load[1])&&((load[1]-load[0])==1))))] (0:0:0 - 1)
		
#if defined(VERI) && !defined(NP)
#if NCLAIMS>1
		{	static int reported3 = 0;
			if (verbose && !reported3)
			{	int nn = (int) ((Pclaim *)pptr(0))->_n;
				printf("depth %ld: Claim %s (%d), state %d (line %d)\n",
					depth, procname[spin_c_typ[nn]], nn, (int) ((Pclaim *)pptr(0))->_p, src_claim[ (int) ((Pclaim *)pptr(0))->_p ]);
				reported3 = 1;
				fflush(stdout);
		}	}
#else
		{	static int reported3 = 0;
			if (verbose && !reported3)
			{	printf("depth %d: Claim, state %d (line %d)\n",
					(int) depth, (int) ((Pclaim *)pptr(0))->_p, src_claim[ (int) ((Pclaim *)pptr(0))->_p ]);
				reported3 = 1;
				fflush(stdout);
		}	}
#endif
#endif
		reached[1][3] = 1;
		if (!((((now.load[0]>=now.load[1])&&((now.load[0]-now.load[1])<=1))||((now.load[0]<now.load[1])&&((now.load[1]-now.load[0])==1)))))
			continue;
		_m = 3; goto P999; /* 0 */
	case 15: // STATE 4 - model.pml:45 - [assert(((load[1]>=0)&&(load[1]<=100)))] (0:0:0 - 1)
		
#if defined(VERI) && !defined(NP)
#if NCLAIMS>1
		{	static int reported4 = 0;
			if (verbose && !reported4)
			{	int nn = (int) ((Pclaim *)pptr(0))->_n;
				printf("depth %ld: Claim %s (%d), state %d (line %d)\n",
					depth, procname[spin_c_typ[nn]], nn, (int) ((Pclaim *)pptr(0))->_p, src_claim[ (int) ((Pclaim *)pptr(0))->_p ]);
				reported4 = 1;
				fflush(stdout);
		}	}
#else
		{	static int reported4 = 0;
			if (verbose && !reported4)
			{	printf("depth %d: Claim, state %d (line %d)\n",
					(int) depth, (int) ((Pclaim *)pptr(0))->_p, src_claim[ (int) ((Pclaim *)pptr(0))->_p ]);
				reported4 = 1;
				fflush(stdout);
		}	}
#endif
#endif
		reached[1][4] = 1;
		spin_assert(((now.load[1]>=0)&&(now.load[1]<=100)), "((load[1]>=0)&&(load[1]<=100))", II, tt, t);
		_m = 3; goto P999; /* 0 */
	case 16: // STATE 5 - model.pml:47 - [((((load[1]>=load[2])&&((load[1]-load[2])<=1))||((load[1]<load[2])&&((load[2]-load[1])==1))))] (0:0:0 - 1)
		
#if defined(VERI) && !defined(NP)
#if NCLAIMS>1
		{	static int reported5 = 0;
			if (verbose && !reported5)
			{	int nn = (int) ((Pclaim *)pptr(0))->_n;
				printf("depth %ld: Claim %s (%d), state %d (line %d)\n",
					depth, procname[spin_c_typ[nn]], nn, (int) ((Pclaim *)pptr(0))->_p, src_claim[ (int) ((Pclaim *)pptr(0))->_p ]);
				reported5 = 1;
				fflush(stdout);
		}	}
#else
		{	static int reported5 = 0;
			if (verbose && !reported5)
			{	printf("depth %d: Claim, state %d (line %d)\n",
					(int) depth, (int) ((Pclaim *)pptr(0))->_p, src_claim[ (int) ((Pclaim *)pptr(0))->_p ]);
				reported5 = 1;
				fflush(stdout);
		}	}
#endif
#endif
		reached[1][5] = 1;
		if (!((((now.load[1]>=now.load[2])&&((now.load[1]-now.load[2])<=1))||((now.load[1]<now.load[2])&&((now.load[2]-now.load[1])==1)))))
			continue;
		_m = 3; goto P999; /* 0 */
	case 17: // STATE 6 - model.pml:49 - [assert(((load[2]>=0)&&(load[2]<=100)))] (0:0:0 - 1)
		
#if defined(VERI) && !defined(NP)
#if NCLAIMS>1
		{	static int reported6 = 0;
			if (verbose && !reported6)
			{	int nn = (int) ((Pclaim *)pptr(0))->_n;
				printf("depth %ld: Claim %s (%d), state %d (line %d)\n",
					depth, procname[spin_c_typ[nn]], nn, (int) ((Pclaim *)pptr(0))->_p, src_claim[ (int) ((Pclaim *)pptr(0))->_p ]);
				reported6 = 1;
				fflush(stdout);
		}	}
#else
		{	static int reported6 = 0;
			if (verbose && !reported6)
			{	printf("depth %d: Claim, state %d (line %d)\n",
					(int) depth, (int) ((Pclaim *)pptr(0))->_p, src_claim[ (int) ((Pclaim *)pptr(0))->_p ]);
				reported6 = 1;
				fflush(stdout);
		}	}
#endif
#endif
		reached[1][6] = 1;
		spin_assert(((now.load[2]>=0)&&(now.load[2]<=100)), "((load[2]>=0)&&(load[2]<=100))", II, tt, t);
		_m = 3; goto P999; /* 0 */
	case 18: // STATE 7 - model.pml:51 - [((((load[2]>=load[3])&&((load[2]-load[3])<=1))||((load[2]<load[3])&&((load[3]-load[2])==1))))] (0:0:0 - 1)
		
#if defined(VERI) && !defined(NP)
#if NCLAIMS>1
		{	static int reported7 = 0;
			if (verbose && !reported7)
			{	int nn = (int) ((Pclaim *)pptr(0))->_n;
				printf("depth %ld: Claim %s (%d), state %d (line %d)\n",
					depth, procname[spin_c_typ[nn]], nn, (int) ((Pclaim *)pptr(0))->_p, src_claim[ (int) ((Pclaim *)pptr(0))->_p ]);
				reported7 = 1;
				fflush(stdout);
		}	}
#else
		{	static int reported7 = 0;
			if (verbose && !reported7)
			{	printf("depth %d: Claim, state %d (line %d)\n",
					(int) depth, (int) ((Pclaim *)pptr(0))->_p, src_claim[ (int) ((Pclaim *)pptr(0))->_p ]);
				reported7 = 1;
				fflush(stdout);
		}	}
#endif
#endif
		reached[1][7] = 1;
		if (!((((now.load[2]>=now.load[3])&&((now.load[2]-now.load[3])<=1))||((now.load[2]<now.load[3])&&((now.load[3]-now.load[2])==1)))))
			continue;
		_m = 3; goto P999; /* 0 */
	case 19: // STATE 8 - model.pml:53 - [assert(((load[3]>=0)&&(load[3]<=100)))] (0:0:0 - 1)
		
#if defined(VERI) && !defined(NP)
#if NCLAIMS>1
		{	static int reported8 = 0;
			if (verbose && !reported8)
			{	int nn = (int) ((Pclaim *)pptr(0))->_n;
				printf("depth %ld: Claim %s (%d), state %d (line %d)\n",
					depth, procname[spin_c_typ[nn]], nn, (int) ((Pclaim *)pptr(0))->_p, src_claim[ (int) ((Pclaim *)pptr(0))->_p ]);
				reported8 = 1;
				fflush(stdout);
		}	}
#else
		{	static int reported8 = 0;
			if (verbose && !reported8)
			{	printf("depth %d: Claim, state %d (line %d)\n",
					(int) depth, (int) ((Pclaim *)pptr(0))->_p, src_claim[ (int) ((Pclaim *)pptr(0))->_p ]);
				reported8 = 1;
				fflush(stdout);
		}	}
#endif
#endif
		reached[1][8] = 1;
		spin_assert(((now.load[3]>=0)&&(now.load[3]<=100)), "((load[3]>=0)&&(load[3]<=100))", II, tt, t);
		_m = 3; goto P999; /* 0 */
	case 20: // STATE 9 - model.pml:55 - [((((load[3]>=load[0])&&((load[3]-load[0])<=1))||((load[3]<load[0])&&((load[0]-load[3])==1))))] (0:0:0 - 1)
		
#if defined(VERI) && !defined(NP)
#if NCLAIMS>1
		{	static int reported9 = 0;
			if (verbose && !reported9)
			{	int nn = (int) ((Pclaim *)pptr(0))->_n;
				printf("depth %ld: Claim %s (%d), state %d (line %d)\n",
					depth, procname[spin_c_typ[nn]], nn, (int) ((Pclaim *)pptr(0))->_p, src_claim[ (int) ((Pclaim *)pptr(0))->_p ]);
				reported9 = 1;
				fflush(stdout);
		}	}
#else
		{	static int reported9 = 0;
			if (verbose && !reported9)
			{	printf("depth %d: Claim, state %d (line %d)\n",
					(int) depth, (int) ((Pclaim *)pptr(0))->_p, src_claim[ (int) ((Pclaim *)pptr(0))->_p ]);
				reported9 = 1;
				fflush(stdout);
		}	}
#endif
#endif
		reached[1][9] = 1;
		if (!((((now.load[3]>=now.load[0])&&((now.load[3]-now.load[0])<=1))||((now.load[3]<now.load[0])&&((now.load[0]-now.load[3])==1)))))
			continue;
		_m = 3; goto P999; /* 0 */
	case 21: // STATE 13 - model.pml:57 - [-end-] (0:0:0 - 1)
		
#if defined(VERI) && !defined(NP)
#if NCLAIMS>1
		{	static int reported13 = 0;
			if (verbose && !reported13)
			{	int nn = (int) ((Pclaim *)pptr(0))->_n;
				printf("depth %ld: Claim %s (%d), state %d (line %d)\n",
					depth, procname[spin_c_typ[nn]], nn, (int) ((Pclaim *)pptr(0))->_p, src_claim[ (int) ((Pclaim *)pptr(0))->_p ]);
				reported13 = 1;
				fflush(stdout);
		}	}
#else
		{	static int reported13 = 0;
			if (verbose && !reported13)
			{	printf("depth %d: Claim, state %d (line %d)\n",
					(int) depth, (int) ((Pclaim *)pptr(0))->_p, src_claim[ (int) ((Pclaim *)pptr(0))->_p ]);
				reported13 = 1;
				fflush(stdout);
		}	}
#endif
#endif
		reached[1][13] = 1;
		if (!delproc(1, II)) continue;
		_m = 3; goto P999; /* 0 */

		 /* PROC Client */
	case 22: // STATE 1 - model.pml:14 - [taskChan[selfid]!newTask] (0:0:0 - 1)
		IfNotBlocked
		reached[0][1] = 1;
		if (q_full(now.taskChan[ Index(((P0 *)_this)->selfid, 4) ]))
			continue;
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[64];
			sprintf(simvals, "%d!", now.taskChan[ Index(((P0 *)_this)->selfid, 4) ]);
		sprintf(simtmp, "%d", 3); strcat(simvals, simtmp);		}
#endif
		
		qsend(now.taskChan[ Index(((P0 *)_this)->selfid, 4) ], 0, 3, 0, 1);
		_m = 2; goto P999; /* 0 */
	case 23: // STATE 2 - model.pml:17 - [queue??taskChan[selfid],response] (0:0:2 - 1)
		reached[0][2] = 1;
		if (q_len(now.queue) == 0) continue;

		XX=1;
		if (!(XX = Q_has(now.queue, 0, 0, 1, 1))) continue;
		(trpt+1)->bup.ovals = grab_ints(2);
		(trpt+1)->bup.ovals[0] = XX;
		(trpt+1)->bup.ovals[1] = now.taskChan[ Index(((P0 *)_this)->selfid, 4) ];
		;
		now.taskChan[ Index(((P0 *)_this)->selfid, 4) ] = qrecv(now.queue, XX-1, 0, 0);
		qrecv(now.queue, XX-1, 1, 1);
		
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[32];
			sprintf(simvals, "%d?", now.queue);
			sprintf(simtmp, "%d", now.taskChan[ Index(((P0 *)_this)->selfid, 4) ]); strcat(simvals, simtmp);
			strcat(simvals, ",");
			sprintf(simtmp, "%d", 1); strcat(simvals, simtmp);
		}
#endif
		;
		_m = 4; goto P999; /* 0 */
	case 24: // STATE 3 - model.pml:18 - [myLoad = (myLoad+1)] (0:0:1 - 1)
		IfNotBlocked
		reached[0][3] = 1;
		(trpt+1)->bup.oval = ((P0 *)_this)->myLoad;
		((P0 *)_this)->myLoad = (((P0 *)_this)->myLoad+1);
#ifdef VAR_RANGES
		logval("Client:myLoad", ((P0 *)_this)->myLoad);
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 25: // STATE 4 - model.pml:19 - [taskChan[selfid]!newTask] (0:0:0 - 1)
		IfNotBlocked
		reached[0][4] = 1;
		if (q_full(now.taskChan[ Index(((P0 *)_this)->selfid, 4) ]))
			continue;
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[64];
			sprintf(simvals, "%d!", now.taskChan[ Index(((P0 *)_this)->selfid, 4) ]);
		sprintf(simtmp, "%d", 3); strcat(simvals, simtmp);		}
#endif
		
		qsend(now.taskChan[ Index(((P0 *)_this)->selfid, 4) ], 0, 3, 0, 1);
		_m = 2; goto P999; /* 0 */
	case 26: // STATE 5 - model.pml:20 - [taskChan[(((selfid+4)-1)%4)]??x] (0:0:2 - 1)
		reached[0][5] = 1;
		if (q_len(now.taskChan[ Index((((((P0 *)_this)->selfid+4)-1)%4), 4) ]) == 0) continue;

		XX=1;
		if (!(XX = Q_has(now.taskChan[ Index((((((P0 *)_this)->selfid+4)-1)%4), 4) ], 0, 0, 0, 0))) continue;
		(trpt+1)->bup.ovals = grab_ints(2);
		(trpt+1)->bup.ovals[0] = XX;
		(trpt+1)->bup.ovals[1] = ((P0 *)_this)->x;
		;
		((P0 *)_this)->x = qrecv(now.taskChan[ Index((((((P0 *)_this)->selfid+4)-1)%4), 4) ], XX-1, 0, 1);
#ifdef VAR_RANGES
		logval("Client:x", ((P0 *)_this)->x);
#endif
		;
		
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[32];
			sprintf(simvals, "%d?", now.taskChan[ Index((((((P0 *)_this)->selfid+4)-1)%4), 4) ]);
			sprintf(simtmp, "%d", ((P0 *)_this)->x); strcat(simvals, simtmp);
		}
#endif
		;
		_m = 4; goto P999; /* 0 */
	case 27: // STATE 6 - model.pml:22 - [((myLoad>(x+1)))] (8:0:2 - 1)
		IfNotBlocked
		reached[0][6] = 1;
		if (!((((P0 *)_this)->myLoad>(((P0 *)_this)->x+1))))
			continue;
		if (TstOnly) return 1; /* TT */
		/* dead 1: x */  (trpt+1)->bup.ovals = grab_ints(2);
		(trpt+1)->bup.ovals[0] = ((P0 *)_this)->x;
#ifdef HAS_CODE
		if (!readtrail)
#endif
			((P0 *)_this)->x = 0;
		/* merge: myLoad = (myLoad-1)(0, 7, 8) */
		reached[0][7] = 1;
		(trpt+1)->bup.ovals[1] = ((P0 *)_this)->myLoad;
		((P0 *)_this)->myLoad = (((P0 *)_this)->myLoad-1);
#ifdef VAR_RANGES
		logval("Client:myLoad", ((P0 *)_this)->myLoad);
#endif
		;
		_m = 3; goto P999; /* 1 */
	case 28: // STATE 8 - model.pml:22 - [taskChan[selfid]!newTask] (0:0:0 - 1)
		IfNotBlocked
		reached[0][8] = 1;
		if (q_full(now.taskChan[ Index(((P0 *)_this)->selfid, 4) ]))
			continue;
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[64];
			sprintf(simvals, "%d!", now.taskChan[ Index(((P0 *)_this)->selfid, 4) ]);
		sprintf(simtmp, "%d", 3); strcat(simvals, simtmp);		}
#endif
		
		qsend(now.taskChan[ Index(((P0 *)_this)->selfid, 4) ], 0, 3, 0, 1);
		_m = 2; goto P999; /* 0 */
	case 29: // STATE 9 - model.pml:22 - [queue!taskChan[(((selfid+4)-1)%4)],request] (0:0:0 - 1)
		IfNotBlocked
		reached[0][9] = 1;
		if (q_full(now.queue))
			continue;
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[64];
			sprintf(simvals, "%d!", now.queue);
		sprintf(simtmp, "%d", now.taskChan[ Index((((((P0 *)_this)->selfid+4)-1)%4), 4) ]); strcat(simvals, simtmp);		strcat(simvals, ",");
		sprintf(simtmp, "%d", 2); strcat(simvals, simtmp);		}
#endif
		
		qsend(now.queue, 0, now.taskChan[ Index((((((P0 *)_this)->selfid+4)-1)%4), 4) ], 2, 2);
		_m = 2; goto P999; /* 0 */
	case 30: // STATE 14 - model.pml:25 - [taskChan[((selfid+1)%4)]??y] (0:0:2 - 1)
		reached[0][14] = 1;
		if (q_len(now.taskChan[ Index(((((P0 *)_this)->selfid+1)%4), 4) ]) == 0) continue;

		XX=1;
		if (!(XX = Q_has(now.taskChan[ Index(((((P0 *)_this)->selfid+1)%4), 4) ], 0, 0, 0, 0))) continue;
		(trpt+1)->bup.ovals = grab_ints(2);
		(trpt+1)->bup.ovals[0] = XX;
		(trpt+1)->bup.ovals[1] = ((P0 *)_this)->y;
		;
		((P0 *)_this)->y = qrecv(now.taskChan[ Index(((((P0 *)_this)->selfid+1)%4), 4) ], XX-1, 0, 1);
#ifdef VAR_RANGES
		logval("Client:y", ((P0 *)_this)->y);
#endif
		;
		
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[32];
			sprintf(simvals, "%d?", now.taskChan[ Index(((((P0 *)_this)->selfid+1)%4), 4) ]);
			sprintf(simtmp, "%d", ((P0 *)_this)->y); strcat(simvals, simtmp);
		}
#endif
		;
		_m = 4; goto P999; /* 0 */
	case 31: // STATE 15 - model.pml:27 - [((myLoad>(y+1)))] (17:0:2 - 1)
		IfNotBlocked
		reached[0][15] = 1;
		if (!((((P0 *)_this)->myLoad>(((P0 *)_this)->y+1))))
			continue;
		if (TstOnly) return 1; /* TT */
		/* dead 1: y */  (trpt+1)->bup.ovals = grab_ints(2);
		(trpt+1)->bup.ovals[0] = ((P0 *)_this)->y;
#ifdef HAS_CODE
		if (!readtrail)
#endif
			((P0 *)_this)->y = 0;
		/* merge: myLoad = (myLoad-1)(0, 16, 17) */
		reached[0][16] = 1;
		(trpt+1)->bup.ovals[1] = ((P0 *)_this)->myLoad;
		((P0 *)_this)->myLoad = (((P0 *)_this)->myLoad-1);
#ifdef VAR_RANGES
		logval("Client:myLoad", ((P0 *)_this)->myLoad);
#endif
		;
		_m = 3; goto P999; /* 1 */
	case 32: // STATE 17 - model.pml:27 - [taskChan[selfid]!newTask] (0:0:0 - 1)
		IfNotBlocked
		reached[0][17] = 1;
		if (q_full(now.taskChan[ Index(((P0 *)_this)->selfid, 4) ]))
			continue;
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[64];
			sprintf(simvals, "%d!", now.taskChan[ Index(((P0 *)_this)->selfid, 4) ]);
		sprintf(simtmp, "%d", 3); strcat(simvals, simtmp);		}
#endif
		
		qsend(now.taskChan[ Index(((P0 *)_this)->selfid, 4) ], 0, 3, 0, 1);
		_m = 2; goto P999; /* 0 */
	case 33: // STATE 18 - model.pml:27 - [queue!taskChan[((selfid+1)%4)],request] (0:0:0 - 1)
		IfNotBlocked
		reached[0][18] = 1;
		if (q_full(now.queue))
			continue;
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[64];
			sprintf(simvals, "%d!", now.queue);
		sprintf(simtmp, "%d", now.taskChan[ Index(((((P0 *)_this)->selfid+1)%4), 4) ]); strcat(simvals, simtmp);		strcat(simvals, ",");
		sprintf(simtmp, "%d", 2); strcat(simvals, simtmp);		}
#endif
		
		qsend(now.queue, 0, now.taskChan[ Index(((((P0 *)_this)->selfid+1)%4), 4) ], 2, 2);
		_m = 2; goto P999; /* 0 */
	case 34: // STATE 26 - model.pml:31 - [-end-] (0:0:0 - 1)
		IfNotBlocked
		reached[0][26] = 1;
		if (!delproc(1, II)) continue;
		_m = 3; goto P999; /* 0 */
	case  _T5:	/* np_ */
		if (!((!(trpt->o_pm&4) && !(trpt->tau&128))))
			continue;
		/* else fall through */
	case  _T2:	/* true */
		_m = 3; goto P999;
#undef rand
	}

