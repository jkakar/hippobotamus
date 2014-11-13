all: update compile release

clean:
	-rm -rf _deps _rel ebin releases

update:
	rebar3 update

compile:
	rebar3 compile

release:
	rebar3 tar -i true -d false

deploy:
	hk slug _rel/hippo/hippo-0.1.0.tar.gz
