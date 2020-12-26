all:
	rm -rf  *Mnesia erl_cra*;
	rm -rf  *~ */*~;
	rm -rf ebin test_ebin/* *.beam test_src/*.beam;
	rm -rf common;
	mkdir ebin;
	cp src/*.app ebin;
	erlc -o ebin src/*.erl
doc_gen:
	rm -rf  node_config logfiles doc/*;
	erlc ../doc_gen.erl;
	erl -s doc_gen start -sname doc
test:
	rm -rf  *Mnesia erl_cra*;
	rm -rf  *~ */*~;
	rm -rf ebin test_ebin/* *.beam test_src/*.beam;
	rm -rf common;
	mkdir ebin;
#	dbase
	cp src/*.app ebin;
	erlc -o ebin src/*.erl;
#	common
	cp ../common/src/*.app ebin;
	erlc -o ebin ../common/src/*.erl;
#	test
	erlc -o test_ebin test_src/*.erl;
#	erl -pa ebin -sname node1 -detached;
	erl -pa ebin -pa test_ebin -s dbase_tests start -sname server -setcookie abc
