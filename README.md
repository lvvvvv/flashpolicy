# FlashPolicy Server write in elixir

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add flashpolicy to your list of dependencies in `mix.exs`:

        def deps do
          [{:flashpolicy, "~> 0.0.1"}]
        end

  2. Ensure flashpolicy is started before your application:

        def application do
          [applications: [:flashpolicy]]
        end

  3. Run it as standalone

        mix run --no-halt

  4. Test with bash script

        perl -e 'printf "<policy-file-request/>%c",0' | nc localhost 843

