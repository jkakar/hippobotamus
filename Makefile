all: update compile release

clean:
	-rm _deps _rel -rf

update:
	rebar3 update

compile:
	rebar3 compile

release:
	./relx -i true --dev-mode false release tar

deploy:
	hk slug _rel/hippo/hippo-0.1.0.tar.gz
