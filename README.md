wallet
=====

An OTP application

Required
------
- Erlang/OTP installed
- rebar3 installed
- docker installed

To run this application
------
Run MYSQL in docker first. Compile then run with rebar3. Below commands are based on Linux/Unbuntu

Build
-----

    $ rebar3 compile
    
Run
-----

    $ rebar3 shell

Run dialyzer
-----

    $ rebar3 dialyzer

Run common test
-----

    $ rebar3 ct

Run MySql in docker
-----

    $ docker compose up

Run Swagger UI in docker
-----

    $ docker run -p 80:8080 -e SWAGGER_JSON=/tmp/swagger.yaml -v `pwd`:/tmp swaggerapi/swagger-ui