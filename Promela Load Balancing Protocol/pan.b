	switch (t->back) {
	default: Uerror("bad return move");
	case  0: goto R999; /* nothing to undo */

		 /* PROC :init: */

	case 3: // STATE 1
		;
		;
		delproc(0, now._nr_pr-1);
		;
		goto R999;

	case 4: // STATE 2
		;
		;
		delproc(0, now._nr_pr-1);
		;
		goto R999;

	case 5: // STATE 3
		;
		;
		delproc(0, now._nr_pr-1);
		;
		goto R999;

	case 6: // STATE 4
		;
		;
		delproc(0, now._nr_pr-1);
		;
		goto R999;

	case 7: // STATE 5
		;
		((P2 *)_this)->i = trpt->bup.oval;
		;
		goto R999;
;
		;
		;
		;
		
	case 10: // STATE 8
		;
		_m = unsend(now.taskChan[ Index(((P2 *)_this)->i, 4) ]);
		;
		goto R999;

	case 11: // STATE 9
		;
		((P2 *)_this)->i = trpt->bup.oval;
		;
		goto R999;

	case 12: // STATE 15
		;
		p_restor(II);
		;
		;
		goto R999;

		 /* CLAIM never_0 */
;
		;
		;
		;
		;
		;
		;
		;
		;
		;
		;
		;
		;
		;
		;
		;
		
	case 21: // STATE 13
		;
		p_restor(II);
		;
		;
		goto R999;

		 /* PROC Client */

	case 22: // STATE 1
		;
		_m = unsend(now.taskChan[ Index(((P0 *)_this)->selfid, 4) ]);
		;
		goto R999;

	case 23: // STATE 2
		;
		XX = trpt->bup.ovals[0];
		unrecv(now.queue, XX-1, 0, now.taskChan[ Index(((P0 *)_this)->selfid, 4) ], 1);
		unrecv(now.queue, XX-1, 1, 1, 0);
		now.taskChan[ Index(((P0 *)_this)->selfid, 4) ] = trpt->bup.ovals[1];
		;
		;
		ungrab_ints(trpt->bup.ovals, 2);
		goto R999;

	case 24: // STATE 3
		;
		((P0 *)_this)->myLoad = trpt->bup.oval;
		;
		goto R999;

	case 25: // STATE 4
		;
		_m = unsend(now.taskChan[ Index(((P0 *)_this)->selfid, 4) ]);
		;
		goto R999;

	case 26: // STATE 5
		;
		XX = trpt->bup.ovals[0];
		unrecv(now.taskChan[ Index((((((P0 *)_this)->selfid+4)-1)%4), 4) ], XX-1, 0, ((P0 *)_this)->x, 1);
		((P0 *)_this)->x = trpt->bup.ovals[1];
		;
		;
		ungrab_ints(trpt->bup.ovals, 2);
		goto R999;

	case 27: // STATE 7
		;
		((P0 *)_this)->myLoad = trpt->bup.ovals[1];
	/* 0 */	((P0 *)_this)->x = trpt->bup.ovals[0];
		;
		;
		ungrab_ints(trpt->bup.ovals, 2);
		goto R999;

	case 28: // STATE 8
		;
		_m = unsend(now.taskChan[ Index(((P0 *)_this)->selfid, 4) ]);
		;
		goto R999;

	case 29: // STATE 9
		;
		_m = unsend(now.queue);
		;
		goto R999;

	case 30: // STATE 14
		;
		XX = trpt->bup.ovals[0];
		unrecv(now.taskChan[ Index(((((P0 *)_this)->selfid+1)%4), 4) ], XX-1, 0, ((P0 *)_this)->y, 1);
		((P0 *)_this)->y = trpt->bup.ovals[1];
		;
		;
		ungrab_ints(trpt->bup.ovals, 2);
		goto R999;

	case 31: // STATE 16
		;
		((P0 *)_this)->myLoad = trpt->bup.ovals[1];
	/* 0 */	((P0 *)_this)->y = trpt->bup.ovals[0];
		;
		;
		ungrab_ints(trpt->bup.ovals, 2);
		goto R999;

	case 32: // STATE 17
		;
		_m = unsend(now.taskChan[ Index(((P0 *)_this)->selfid, 4) ]);
		;
		goto R999;

	case 33: // STATE 18
		;
		_m = unsend(now.queue);
		;
		goto R999;

	case 34: // STATE 26
		;
		p_restor(II);
		;
		;
		goto R999;
	}

